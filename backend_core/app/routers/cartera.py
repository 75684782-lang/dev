from datetime import date
from fastapi import APIRouter, HTTPException, Depends
from app.db import supabase
from app.middleware.auth import get_current_user

router = APIRouter(prefix="/cartera", tags=["cartera"])


@router.get("/")
async def listar_cartera(current_user: dict = Depends(get_current_user)):
    if current_user["rol"] not in ("operador", "administrador", "supervisor"):
        raise HTTPException(status_code=403, detail="Solo operadores pueden ver la cartera")

    result = supabase.table("cartera_diaria")\
        .select("*, clientes_ficha!inner(id, nombre_completo, telefono, negocio_nombre, ubicacion_lat, ubicacion_lng)")\
        .eq("asesor_id", current_user["user_id"])\
        .eq("fecha_asignacion", date.today().isoformat())\
        .execute()

    data = []
    for row in result.data:
        solicitud = supabase.table("solicitudes_credito")\
            .select("numero_expediente, monto_solicitado, estado, plazo_meses, garantia, destino_credito, con_desgravamen, creado_en")\
            .eq("cliente_id", row["clientes_ficha"]["id"])\
            .order("creado_en", desc=True)\
            .limit(1)\
            .execute()

        item = {
            "id": row["id"],
            "cliente": row["clientes_ficha"]["nombre_completo"],
            "telefono": row["clientes_ficha"]["telefono"],
            "negocio": row["clientes_ficha"]["negocio_nombre"],
            "tipo_gestion": row["tipo_gestion"],
            "prioridad": row["prioridad"],
            "visitado": row["visitado"],
            "ubicacion_lat": row["clientes_ficha"]["ubicacion_lat"],
            "ubicacion_lng": row["clientes_ficha"]["ubicacion_lng"],
        }
        if solicitud.data:
            s = solicitud.data[0]
            item["solicitud"] = {
                "numero_expediente": s["numero_expediente"],
                "monto_solicitado": float(s["monto_solicitado"]),
                "estado": s["estado"],
                "plazo_meses": s["plazo_meses"],
                "garantia": s["garantia"],
                "destino_credito": s["destino_credito"],
                "con_desgravamen": s["con_desgravamen"],
                "creado_en": s["creado_en"],
            }
        data.append(item)
    return {"data": data}


@router.get("/ruta")
async def obtener_ruta_optima(current_user: dict = Depends(get_current_user)):
    if current_user["rol"] not in ("operador", "administrador"):
        raise HTTPException(status_code=403, detail="No autorizado")

    result = supabase.table("cartera_diaria")\
        .select("*, clientes_ficha!inner(*)")\
        .eq("asesor_id", current_user["user_id"])\
        .eq("fecha_asignacion", date.today().isoformat())\
        .order("prioridad", desc=False)\
        .execute()

    prioridad_valor = {"ALTA": 0, "MEDIA": 1, "NORMAL": 2}
    data = []
    for row in result.data:
        data.append({
            "id": row["id"],
            "cliente": row["clientes_ficha"]["nombre_completo"],
            "tipo_gestion": row["tipo_gestion"],
            "prioridad": row["prioridad"],
            "visitado": row["visitado"],
            "negocio": row["clientes_ficha"]["negocio_nombre"],
            "ubicacion_lat": row["clientes_ficha"]["ubicacion_lat"],
            "ubicacion_lng": row["clientes_ficha"]["ubicacion_lng"],
            "prioridad_orden": prioridad_valor.get(row["prioridad"], 99),
        })
    data.sort(key=lambda c: (c["prioridad_orden"], c["visitado"]))
    return {"data": data}


@router.get("/fv")
async def listar_cartera_fv_rol(current_user: dict = Depends(get_current_user)):
    result = supabase.table("cartera_diaria")\
        .select("*, clientes_ficha!inner(id, nombre_completo, telefono, negocio_nombre, ubicacion_lat, ubicacion_lng)")\
        .eq("asesor_negocio_id", current_user["user_id"])\
        .eq("fecha_asignacion", date.today().isoformat())\
        .execute()

    data = []
    for row in result.data:
        cli = row["clientes_ficha"]
        data.append({
            "id": row["id"],
            "nombre": cli["nombre_completo"],
            "telefono": cli.get("telefono", ""),
            "negocio": cli.get("negocio_nombre", ""),
            "tipo_gestion": row["tipo_gestion"],
            "prioridad": row["prioridad"],
            "visitado": row.get("visitado", False),
            "lat": cli.get("ubicacion_lat"),
            "lng": cli.get("ubicacion_lng"),
        })
    return {"data": data}


@router.post("/{cartera_id}/checkin")
async def checkin_visita(cartera_id: str, lat: float, lng: float, current_user: dict = Depends(get_current_user)):
    supabase.table("cartera_diaria").update({
        "visitado": True,
    }).eq("id", cartera_id).execute()

    cartera = supabase.table("cartera_diaria").select("cliente_id").eq("id", cartera_id).execute()
    if cartera.data:
        supabase.table("clientes_ficha").update({
            "ubicacion_lat": lat,
            "ubicacion_lng": lng,
        }).eq("id", cartera.data[0]["cliente_id"]).execute()

    return {"mensaje": "Check-in registrado", "visitado": True}
