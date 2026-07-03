from fastapi import APIRouter, HTTPException
from app.db import supabase

router = APIRouter(prefix="/buro", tags=["buro"])

SBS_MAP = {
    "0": {"calificacion": "NORMAL", "entidades": 1, "deuda_total": 4500, "dias_mora": 0, "inhabilitado": False},
    "1": {"calificacion": "NORMAL", "entidades": 2, "deuda_total": 12000, "dias_mora": 0, "inhabilitado": False},
    "2": {"calificacion": "CPP", "entidades": 2, "deuda_total": 18000, "dias_mora": 15, "inhabilitado": False},
    "3": {"calificacion": "NORMAL", "entidades": 0, "deuda_total": 0, "dias_mora": 0, "inhabilitado": False},
    "4": {"calificacion": "DUDOSO", "entidades": 3, "deuda_total": 25000, "dias_mora": 95, "inhabilitado": False},
    "5": {"calificacion": "DEFICIENTE", "entidades": 2, "deuda_total": 16000, "dias_mora": 45, "inhabilitado": False},
    "6": {"calificacion": "NORMAL", "entidades": 1, "deuda_total": 6000, "dias_mora": 0, "inhabilitado": False},
    "7": {"calificacion": "PERDIDA", "entidades": 4, "deuda_total": 40000, "dias_mora": 210, "inhabilitado": True},
    "8": {"calificacion": "CPP", "entidades": 1, "deuda_total": 9000, "dias_mora": 20, "inhabilitado": False},
    "9": {"calificacion": "NORMAL", "entidades": 2, "deuda_total": 14000, "dias_mora": 0, "inhabilitado": False},
}


@router.get("/{dni}")
async def consultar_buro(dni: str):
    if len(dni) != 8 or not dni.isdigit():
        raise HTTPException(status_code=400, detail="DNI debe tener 8 dígitos")

    ultimo = dni[-1]
    perfil = SBS_MAP.get(ultimo, SBS_MAP["0"])

    return {
        "dni": dni,
        "calificacion": perfil["calificacion"],
        "entidades_con_deuda": perfil["entidades"],
        "deuda_total": perfil["deuda_total"],
        "dias_mayor_mora": perfil["dias_mora"],
        "inhabilitado": perfil["inhabilitado"],
    }
