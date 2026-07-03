import bcrypt
from fastapi import APIRouter, Depends, HTTPException
from app.db import supabase
from app.models.schemas import LoginRequest, RegistroRequest, TokenResponse, FVLoginRequest, FVTokenResponse
from app.middleware.auth import create_access_token, get_current_user

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/login", response_model=TokenResponse)
async def login(req: LoginRequest):
    result = supabase.table("usuarios").select("*").eq("dni", req.dni).execute()
    if not result.data:
        raise HTTPException(status_code=401, detail="Credenciales inválidas")

    user = result.data[0]
    if not bcrypt.checkpw(req.clave.encode(), user["clave_hash"].encode()):
        raise HTTPException(status_code=401, detail="Credenciales inválidas")

    token = create_access_token(user_id=user["id"], dni=user["dni"], rol=user["rol"])
    return TokenResponse(access_token=token, rol=user["rol"], usuario_id=user["id"])


@router.post("/registro", response_model=TokenResponse)
async def registro(req: RegistroRequest):
    existe = supabase.table("usuarios").select("id").eq("dni", req.dni).execute()
    if existe.data:
        raise HTTPException(status_code=409, detail="El DNI ya está registrado")

    clave_hashed = bcrypt.hashpw(req.clave.encode(), bcrypt.gensalt()).decode()

    user_resp = supabase.table("usuarios").insert({
        "dni": req.dni,
        "clave_hash": clave_hashed,
        "rol": "cliente",
    }).execute()

    user = user_resp.data[0]

    supabase.table("clientes_ficha").insert({
        "usuario_id": user["id"],
        "nombre_completo": req.nombre_completo,
        "telefono": req.telefono,
        "negocio_nombre": req.negocio_nombre or "",
    }).execute()

    token = create_access_token(user_id=user["id"], dni=user["dni"], rol="cliente")
    return TokenResponse(access_token=token, rol="cliente", usuario_id=user["id"])


@router.post("/fv-login", response_model=FVTokenResponse)
async def fv_login(req: FVLoginRequest):
    result = supabase.table("asesores_negocio").select("*").eq("codigo_empleado", req.codigo_empleado).execute()
    if not result.data:
        raise HTTPException(status_code=401, detail="Credenciales inválidas")

    asesor = result.data[0]
    if not bcrypt.checkpw(req.clave.encode(), asesor["clave_hash"].encode()):
        raise HTTPException(status_code=401, detail="Credenciales inválidas")

    if not asesor.get("activo", True):
        raise HTTPException(status_code=403, detail="Cuenta desactivada")

    token = create_access_token(user_id=asesor["id"], dni=asesor["codigo_empleado"], rol=asesor["perfil"])
    return FVTokenResponse(
        access_token=token,
        perfil=asesor["perfil"],
        asesor_id=asesor["id"],
        nombres=asesor["nombres"],
        apellidos=asesor["apellidos"],
        agencia_id=asesor.get("agencia_id", ""),
    )


@router.get("/fv-perfil")
async def fv_perfil(current_user: dict = Depends(get_current_user)):
    result = supabase.table("asesores_negocio").select("*, agencias!inner(nombre, region)").eq("id", current_user["user_id"]).execute()
    if not result.data:
        raise HTTPException(status_code=404, detail="Asesor no encontrado")
    return result.data[0]
