from fastapi import APIRouter, HTTPException
from app.db import supabase

router = APIRouter(prefix="/cronograma", tags=["cronograma"])


@router.get("/{expediente}")
async def obtener_cronograma(expediente: str):
    solicitud = supabase.table("solicitudes_credito")\
        .select("id").eq("numero_expediente", expediente).execute()

    if not solicitud.data:
        raise HTTPException(status_code=404, detail="Solicitud no encontrada")

    s_id = solicitud.data[0]["id"]
    result = supabase.table("cronogramas")\
        .select("*")\
        .eq("solicitud_id", s_id)\
        .order("numero_cuota")\
        .execute()

    data = [{
        "cuota": r["numero_cuota"],
        "fecha": r["fecha_pago"],
        "monto": float(r["monto_cuota"]),
        "capital": float(r["capital"]),
        "interes": float(r["interes"]),
        "saldo": float(r["saldo_pendiente"]),
    } for r in result.data]

    return {"expediente": expediente, "data": data}
