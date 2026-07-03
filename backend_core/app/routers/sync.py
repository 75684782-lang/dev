from fastapi import APIRouter
from app.db import supabase

router = APIRouter(prefix="/sync", tags=["sync"])


@router.post("/outbox")
async def receive_sync(data: dict):
    result = supabase.table("sync_outbox").insert({
        "operacion": data.get("operacion", ""),
        "datos_json": data.get("datos_json", {}),
        "pendiente_sync": False,
    }).execute()
    return {
        "status": "received",
        "id": result.data[0]["id"] if result.data else None,
    }
