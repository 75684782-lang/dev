from fastapi import APIRouter, HTTPException, Depends
from app.db import supabase
from app.middleware.auth import get_current_user

router = APIRouter(prefix="/clientes", tags=["clientes"])


@router.get("/buscar/{dni}")
async def buscar_cliente_por_dni(dni: str, current_user: dict = Depends(get_current_user)):
    if len(dni) != 8 or not dni.isdigit():
        raise HTTPException(status_code=400, detail="DNI debe tener 8 dígitos")

    user = supabase.table("usuarios").select("id").eq("dni", dni).execute()
    if not user.data:
        raise HTTPException(status_code=404, detail="Cliente no encontrado")

    ficha = supabase.table("clientes_ficha")\
        .select("id, nombre_completo, telefono, negocio_nombre")\
        .eq("usuario_id", user.data[0]["id"])\
        .execute()

    if not ficha.data:
        raise HTTPException(status_code=404, detail="Cliente no tiene ficha registrada")

    c = ficha.data[0]
    return {
        "id": c["id"],
        "nombre_completo": c["nombre_completo"],
        "telefono": c["telefono"],
        "negocio_nombre": c["negocio_nombre"],
        "dni": dni,
    }
