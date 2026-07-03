import os
import uuid
from fastapi import APIRouter, HTTPException, Depends, UploadFile, File
from app.db import supabase
from app.middleware.auth import get_current_user

router = APIRouter(prefix="/upload", tags=["upload"])

BUCKET_NAME = "expedientes"
ALLOWED_TYPES = {"image/jpeg", "image/png", "image/webp", "application/pdf"}


@router.post("/inicializar-bucket")
async def inicializar_bucket(current_user: dict = Depends(get_current_user)):
    if current_user["rol"] not in ("administrador", "supervisor"):
        raise HTTPException(status_code=403, detail="Solo administradores pueden inicializar buckets")

    try:
        supabase.storage.create_bucket(BUCKET_NAME, options={"public": False})
        return {"mensaje": f"Bucket '{BUCKET_NAME}' creado exitosamente"}
    except Exception as e:
        return {"mensaje": f"Bucket ya existe o error: {str(e)}"}


@router.post("/{expediente}")
async def subir_archivo(
    expediente: str,
    tipo: str,
    file: UploadFile = File(...),
    current_user: dict = Depends(get_current_user),
):
    solicitud = supabase.table("solicitudes_credito")\
        .select("id, asesor_id").eq("numero_expediente", expediente).execute()

    if not solicitud.data:
        raise HTTPException(status_code=404, detail="Solicitud no encontrada")

    s = solicitud.data[0]
    if s["asesor_id"] != current_user["user_id"] and current_user["rol"] not in ("administrador", "supervisor"):
        raise HTTPException(status_code=403, detail="No autorizado para esta solicitud")

    if file.content_type not in ALLOWED_TYPES:
        raise HTTPException(status_code=400, detail=f"Tipo de archivo no permitido: {file.content_type}")

    ext = file.filename.split(".")[-1] if "." in file.filename else "jpg"
    object_name = f"{expediente}/{tipo}_{uuid.uuid4().hex[:8]}.{ext}"

    content = await file.read()
    if len(content) > 10 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="Archivo demasiado grande (máximo 10MB)")

    try:
        supabase.storage.from_(BUCKET_NAME).upload(
            path=object_name,
            file=content,
            file_options={"content-type": file.content_type},
        )
        supabase_url = os.getenv("SUPABASE_URL", "")
        url = f"{supabase_url}/storage/v1/object/public/{BUCKET_NAME}/{object_name}"

        supabase.table("solicitudes_credito").update({
            f"documento_{tipo}": url,
        }).eq("id", s["id"]).execute()

        return {
            "mensaje": "Archivo subido exitosamente",
            "url": url,
            "tipo": tipo,
            "expediente": expediente,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al subir archivo: {str(e)}")
