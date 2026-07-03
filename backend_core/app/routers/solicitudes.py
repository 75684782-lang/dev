import uuid
from collections import Counter
from datetime import date
from fastapi import APIRouter, HTTPException, Depends
from typing import Optional
from app.db import supabase
from app.models.schemas import (
    SimularRequest, SimularResponse, SimularEducativoResponse,
    SolicitudRequest, SolicitudResponse, SolicitudUpdate, EstadoUpdate,
    CondicionarRequest, EvaluacionRequest
)
from app.services.financiero import (
    calcular_cronograma, calcular_cronograma_educativo, validar_capacidad_pago
)
from app.middleware.auth import get_current_user

router = APIRouter(prefix="/solicitudes", tags=["solicitudes"])

LINEA_TIEMPO = [
    {"estado": "enviado", "label": "Recibido", "icono": "📩", "orden": 0},
    {"estado": "en_evaluacion", "label": "En Evaluación", "icono": "🔍", "orden": 1},
    {"estado": "aprobado", "label": "Aprobado", "icono": "✅", "orden": 2},
    {"estado": "desembolsado", "label": "Desembolsado", "icono": "💰", "orden": 3},
]


@router.post("/simular", response_model=SimularResponse)
async def simular_credito(req: SimularRequest):
    return calcular_cronograma(req)


@router.post("/simular/educativo", response_model=SimularEducativoResponse)
async def simular_educativo(monto: float, plazo: int):
    if monto <= 0 or plazo <= 0:
        raise HTTPException(status_code=400, detail="Monto y plazo deben ser positivos")
    return calcular_cronograma_educativo(monto, plazo)


@router.post("/validar-capacidad")
async def validar_capacidad(req: EvaluacionRequest):
    return validar_capacidad_pago(
        req.ingresos_mensuales, req.costos_mercaderia,
        req.gastos_familiares, req.cuota_simulada
    )


@router.post("/", response_model=SolicitudResponse)
async def crear_solicitud(req: SolicitudRequest, current_user: dict = Depends(get_current_user)):
    if current_user["rol"] not in ("operador", "administrador"):
        raise HTTPException(status_code=403, detail="Solo los operadores pueden crear solicitudes")

    cliente_id = req.cliente_id
    if not cliente_id and req.dni:
        user = supabase.table("usuarios").select("id").eq("dni", req.dni).execute()
        if not user.data:
            raise HTTPException(status_code=404, detail="Cliente no encontrado")
        ficha = supabase.table("clientes_ficha").select("id").eq("usuario_id", user.data[0]["id"]).execute()
        if not ficha.data:
            raise HTTPException(status_code=404, detail="Cliente no tiene ficha registrada")
        cliente_id = ficha.data[0]["id"]
    elif not cliente_id:
        raise HTTPException(status_code=400, detail="cliente_id o dni requerido")

    expediente = f"EXP-2026-{uuid.uuid4().hex[:4].upper()}"
    tea = 40.92 if req.con_desgravamen else 43.92

    result = supabase.table("solicitudes_credito").insert({
        "numero_expediente": expediente,
        "cliente_id": cliente_id,
        "asesor_id": current_user["user_id"],
        "monto_solicitado": req.monto_solicitado,
        "plazo_meses": req.plazo_meses,
        "tea": tea,
        "con_desgravamen": req.con_desgravamen,
        "garantia": req.garantia or "",
        "destino_credito": req.destino_credito or "",
        "estado": "enviado",
    }).execute()

    s = result.data[0]

    supabase.table("cartera_diaria").insert({
        "asesor_id": current_user["user_id"],
        "cliente_id": cliente_id,
        "tipo_gestion": "NUEVA_SOLICITUD",
        "prioridad": "MEDIA",
        "fecha_asignacion": date.today().isoformat(),
    }).execute()

    return SolicitudResponse(
        id=s["id"], numero_expediente=expediente,
        estado="enviado", mensaje=f"Solicitud {expediente} registrada exitosamente"
    )


@router.put("/{expediente}")
async def actualizar_solicitud(expediente: str, update: SolicitudUpdate, current_user: dict = Depends(get_current_user)):
    if current_user["rol"] not in ("operador", "administrador"):
        raise HTTPException(status_code=403, detail="No autorizado")

    payload = {}
    if update.monto_solicitado is not None:
        payload["monto_solicitado"] = update.monto_solicitado
    if update.plazo_meses is not None:
        payload["plazo_meses"] = update.plazo_meses
    if update.con_desgravamen is not None:
        payload["con_desgravamen"] = update.con_desgravamen
    if update.garantia is not None:
        payload["garantia"] = update.garantia
    if update.destino_credito is not None:
        payload["destino_credito"] = update.destino_credito
    if payload:
        payload["estado"] = "en_evaluacion"
        supabase.table("solicitudes_credito").update(payload).eq("numero_expediente", expediente).execute()

    return {"expediente": expediente, "estado": "en_evaluacion", "mensaje": f"Solicitud {expediente} actualizada"}


@router.patch("/{expediente}/estado")
async def actualizar_estado(expediente: str, update: EstadoUpdate, current_user: dict = Depends(get_current_user)):
    VALIDOS = {"aprobado", "rechazado", "condicionado", "en_evaluacion", "recibido_comite", "desembolsado"}
    if update.estado not in VALIDOS:
        raise HTTPException(status_code=400, detail="Estado inválido")
    if update.estado == "rechazado" and not update.motivo_rechazo:
        raise HTTPException(status_code=400, detail="Motivo de rechazo requerido")

    payload = {"estado": update.estado}
    if update.motivo_rechazo:
        payload["motivo_rechazo"] = update.motivo_rechazo

    supabase.table("solicitudes_credito").update(payload).eq("numero_expediente", expediente).execute()

    return {
        "expediente": expediente,
        "estado": update.estado,
        "motivo": update.motivo_rechazo,
    }


@router.get("/")
async def listar_solicitudes(current_user: dict = Depends(get_current_user)):
    result = supabase.table("solicitudes_credito")\
        .select("*, clientes_ficha!inner(nombre_completo)")\
        .order("creado_en", desc=True)\
        .execute()

    data = []
    for row in result.data:
        data.append({
            "id": row["id"],
            "numero_expediente": row["numero_expediente"],
            "cliente_id": row["cliente_id"],
            "cliente": row["clientes_ficha"]["nombre_completo"],
            "monto": float(row["monto_solicitado"]),
            "plazo_meses": row["plazo_meses"],
            "estado": row["estado"],
        })
    return {"data": data}


@router.get("/mias")
async def listar_mis_solicitudes(current_user: dict = Depends(get_current_user)):
    if current_user["rol"] != "cliente":
        raise HTTPException(status_code=403, detail="Solo clientes pueden ver sus solicitudes")

    ficha = supabase.table("clientes_ficha").select("id").eq("usuario_id", current_user["user_id"]).execute()
    if not ficha.data:
        raise HTTPException(status_code=404, detail="Perfil de cliente no encontrado")

    cliente_id = ficha.data[0]["id"]
    result = supabase.table("solicitudes_credito")\
        .select("*, clientes_ficha!inner(nombre_completo)")\
        .eq("cliente_id", cliente_id)\
        .order("creado_en", desc=True)\
        .execute()

    data = []
    for row in result.data:
        data.append({
            "id": row["id"],
            "numero_expediente": row["numero_expediente"],
            "cliente_id": row["cliente_id"],
            "cliente": row["clientes_ficha"]["nombre_completo"],
            "monto": float(row["monto_solicitado"]),
            "plazo_meses": row["plazo_meses"],
            "estado": row["estado"],
            "creado_en": row["creado_en"],
        })
    return {"data": data}


@router.post("/solicitar")
async def solicitar_credito(req: SolicitudRequest, current_user: dict = Depends(get_current_user)):
    if current_user["rol"] != "cliente":
        raise HTTPException(status_code=403, detail="Solo clientes pueden usar este endpoint")

    ficha = supabase.table("clientes_ficha").select("id").eq("usuario_id", current_user["user_id"]).execute()
    if not ficha.data:
        raise HTTPException(status_code=404, detail="Perfil de cliente no encontrado")

    operador = supabase.table("usuarios").select("id").eq("dni", "11111111").execute()
    if not operador.data:
        raise HTTPException(status_code=500, detail="No hay operador disponible")
    operador_id = operador.data[0]["id"]

    expediente = f"EXP-2026-{uuid.uuid4().hex[:4].upper()}"
    tea = 40.92 if req.con_desgravamen else 43.92

    result = supabase.table("solicitudes_credito").insert({
        "numero_expediente": expediente,
        "cliente_id": ficha.data[0]["id"],
        "asesor_id": operador_id,
        "monto_solicitado": req.monto_solicitado,
        "plazo_meses": req.plazo_meses,
        "tea": tea,
        "con_desgravamen": req.con_desgravamen,
        "garantia": req.garantia or "",
        "destino_credito": req.destino_credito or "",
        "estado": "enviado",
    }).execute()

    s = result.data[0]

    supabase.table("cartera_diaria").insert({
        "asesor_id": operador_id,
        "cliente_id": ficha.data[0]["id"],
        "tipo_gestion": "NUEVA_SOLICITUD",
        "prioridad": "MEDIA",
        "fecha_asignacion": date.today().isoformat(),
    }).execute()

    return SolicitudResponse(
        id=s["id"], numero_expediente=expediente,
        estado="enviado", mensaje=f"Solicitud {expediente} registrada"
    )


@router.get("/desembolsables")
async def listar_desembolsables(current_user: dict = Depends(get_current_user)):
    result = supabase.table("solicitudes_credito")\
        .select("*, clientes_ficha!inner(nombre_completo, telefono, negocio_nombre)")\
        .in_("estado", ["aprobado", "condicionado"])\
        .order("creado_en", desc=True)\
        .execute()

    data = []
    for row in result.data:
        data.append({
            "id": row["id"],
            "numero_expediente": row["numero_expediente"],
            "cliente_id": row["cliente_id"],
            "cliente": row["clientes_ficha"]["nombre_completo"],
            "telefono": row["clientes_ficha"]["telefono"],
            "negocio": row["clientes_ficha"]["negocio_nombre"],
            "monto": float(row["monto_solicitado"]),
            "plazo_meses": row["plazo_meses"],
            "tea": float(row["tea"]),
            "con_desgravamen": row["con_desgravamen"],
            "estado": row["estado"],
            "creado_en": row["creado_en"],
        })
    return {"data": data}


@router.get("/estadisticas")
async def obtener_estadisticas(current_user: dict = Depends(get_current_user)):
    result = supabase.table("solicitudes_credito").select("monto_solicitado, estado, plazo_meses, creado_en").execute()
    rows = result.data

    total_colocado = sum(float(r["monto_solicitado"]) for r in rows if r["estado"] == "desembolsado")
    aprobados = sum(1 for r in rows if r["estado"] in ("aprobado", "desembolsado"))
    rechazados = sum(1 for r in rows if r["estado"] == "rechazado")
    total = len(rows)
    tasa_aprobacion = round(aprobados / total * 100, 1) if total > 0 else 0
    monto_promedio = round(sum(float(r["monto_solicitado"]) for r in rows) / total, 2) if total > 0 else 0

    from collections import Counter
    estados_count = Counter(r["estado"] for r in rows)

    return {
        "total_solicitudes": total,
        "total_colocado": round(total_colocado, 2),
        "aprobados": aprobados,
        "rechazados": rechazados,
        "tasa_aprobacion": tasa_aprobacion,
        "monto_promedio": monto_promedio,
        "distribucion_estados": dict(estados_count),
    }


@router.get("/{expediente}")
async def obtener_solicitud(expediente: str, current_user: dict = Depends(get_current_user)):
    result = supabase.table("solicitudes_credito")\
        .select("*, clientes_ficha!inner(nombre_completo, telefono, negocio_nombre)")\
        .eq("numero_expediente", expediente)\
        .execute()

    if not result.data:
        raise HTTPException(status_code=404, detail="Solicitud no encontrada")

    row = result.data[0]
    estados = [
        {**e, "activo": e["orden"] <= next(
            (lt["orden"] for lt in LINEA_TIEMPO if lt["estado"] == row["estado"]), 0
        )}
        for e in LINEA_TIEMPO
    ]

    return {
        "id": row["id"],
        "numero_expediente": row["numero_expediente"],
        "cliente": row["clientes_ficha"]["nombre_completo"],
        "telefono": row["clientes_ficha"]["telefono"],
        "negocio": row["clientes_ficha"]["negocio_nombre"],
        "monto_solicitado": float(row["monto_solicitado"]),
        "plazo_meses": row["plazo_meses"],
        "tea": float(row["tea"]),
        "estado": row["estado"],
        "con_desgravamen": row["con_desgravamen"],
        "garantia": row["garantia"],
        "destino_credito": row["destino_credito"],
        "motivo_rechazo": row.get("motivo_rechazo"),
        "creado_en": row["creado_en"],
        "linea_tiempo": estados,
    }


@router.post("/{expediente}/condicionar")
async def condicionar_solicitud(expediente: str, req: CondicionarRequest, current_user: dict = Depends(get_current_user)):
    supabase.table("solicitudes_credito").update({
        "estado": "condicionado",
        "monto_solicitado": req.monto_modificado,
        "plazo_meses": req.plazo_modificado,
        "motivo_rechazo": req.motivo,
    }).eq("numero_expediente", expediente).execute()

    return {
        "expediente": expediente,
        "estado": "condicionado",
        "monto_modificado": req.monto_modificado,
        "plazo_modificado": req.plazo_modificado,
        "motivo": req.motivo,
    }


@router.post("/{expediente}/desembolsar")
async def desembolsar(expediente: str, current_user: dict = Depends(get_current_user)):
    solicitud = supabase.table("solicitudes_credito")\
        .select("*").eq("numero_expediente", expediente).execute()

    if not solicitud.data:
        raise HTTPException(status_code=404, detail="Solicitud no encontrada")

    s = solicitud.data[0]
    req = SimularRequest(
        monto=float(s["monto_solicitado"]),
        plazo_meses=s["plazo_meses"],
        con_desgravamen=s["con_desgravamen"],
    )
    cronograma = calcular_cronograma(req)

    supabase.table("solicitudes_credito").update({"estado": "desembolsado"}).eq("id", s["id"]).execute()

    for cuota in cronograma.cronograma:
        supabase.table("cronogramas").insert({
            "solicitud_id": s["id"],
            "numero_cuota": cuota.numero,
            "fecha_pago": cuota.fecha_pago.isoformat(),
            "monto_cuota": cuota.monto_cuota,
            "capital": cuota.capital,
            "interes": cuota.interes,
            "saldo_pendiente": cuota.saldo_pendiente,
        }).execute()

    return {
        "expediente": expediente,
        "estado": "desembolsado",
        "cronograma_generado": True,
        "mensaje": f"Crédito {expediente} desembolsado. {len(cronograma.cronograma)} cuotas generadas.",
    }
