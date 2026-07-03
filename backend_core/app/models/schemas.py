from pydantic import BaseModel, Field
from typing import Optional
from datetime import date, datetime


class LoginRequest(BaseModel):
    dni: str = Field(..., min_length=8, max_length=8)
    clave: str = Field(..., min_length=4)


class RegistroRequest(BaseModel):
    dni: str = Field(..., min_length=8, max_length=8)
    clave: str = Field(..., min_length=4)
    nombre_completo: str = Field(..., min_length=3)
    telefono: str = Field(..., min_length=9)
    negocio_nombre: Optional[str] = None


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    rol: str
    usuario_id: str


class SimularRequest(BaseModel):
    monto: float = Field(..., gt=0)
    plazo_meses: int = Field(..., ge=1, le=60)
    con_desgravamen: bool = True


class SimularEducativoResponse(BaseModel):
    tea: float
    tem: float
    cuota_fija: float
    total_intereses: float
    total_pagar: float
    porcentaje_capital: float
    porcentaje_interes: float
    cronograma: list["Cuota"]


class Cuota(BaseModel):
    numero: int
    fecha_pago: date
    monto_cuota: float
    capital: float
    interes: float
    saldo_pendiente: float


class SimularResponse(BaseModel):
    tea: float
    tem: float
    cuota_fija: float
    total_intereses: float
    total_pagar: float
    cronograma: list[Cuota]


class SolicitudRequest(BaseModel):
    cliente_id: str = ""
    dni: Optional[str] = None
    monto_solicitado: float = Field(..., gt=0)
    plazo_meses: int = Field(..., ge=1, le=60)
    con_desgravamen: bool = True
    garantia: Optional[str] = None
    destino_credito: Optional[str] = None


class SolicitudResponse(BaseModel):
    id: str
    numero_expediente: str
    estado: str
    mensaje: str


class SolicitudUpdate(BaseModel):
    monto_solicitado: Optional[float] = None
    plazo_meses: Optional[int] = None
    con_desgravamen: Optional[bool] = None
    garantia: Optional[str] = None
    destino_credito: Optional[str] = None


class EstadoUpdate(BaseModel):
    estado: str
    motivo_rechazo: Optional[str] = None
    monto_condicionado: Optional[float] = None
    plazo_condicionado: Optional[int] = None


class CheckInRequest(BaseModel):
    cliente_cartera_id: str
    ubicacion_lat: float
    ubicacion_lng: float


class EvaluacionRequest(BaseModel):
    cliente_id: str
    asesor_id: str
    ingresos_diarios: Optional[float] = 0
    ingresos_mensuales: float
    costos_mercaderia: float
    gastos_familiares: float
    excedente_familiar: float
    monto_solicitado: float
    plazo_meses: int
    cuota_simulada: float
    capacidad_suficiente: bool


class CondicionarRequest(BaseModel):
    monto_modificado: float = Field(..., gt=0)
    plazo_modificado: int = Field(..., ge=1, le=60)
    motivo: str


class FVLoginRequest(BaseModel):
    codigo_empleado: str = Field(..., min_length=1, max_length=10)
    clave: str = Field(..., min_length=4)


class FVTokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    perfil: str
    asesor_id: str
    nombres: str
    apellidos: str
    agencia_id: str


class VisitaResultadoRequest(BaseModel):
    cartera_id: str
    estado_visita: str
    resultado_visita: Optional[str] = None
    observacion_visita: Optional[str] = None
    lat: Optional[float] = None
    lng: Optional[float] = None
