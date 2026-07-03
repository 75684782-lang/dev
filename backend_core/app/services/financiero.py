import math
from datetime import date, timedelta
from app.models.schemas import SimularRequest, SimularResponse, SimularEducativoResponse, Cuota


def _calcular_cronograma(monto: float, plazo: int, tea: float) -> SimularResponse:
    TEM = pow(1 + tea / 100, 1 / 12) - 1
    cuota_fija = monto * (TEM * pow(1 + TEM, plazo)) / (pow(1 + TEM, plazo) - 1)
    saldo = monto
    total_intereses = 0.0
    cronograma = []
    today = date.today()

    for i in range(1, plazo + 1):
        fecha_pago = today.replace(day=1) + timedelta(days=32 * i)
        fecha_pago = fecha_pago.replace(day=1)
        interes = saldo * TEM
        capital = cuota_fija - interes
        if i == plazo:
            capital = saldo
            cuota_fija = capital + interes
        saldo -= capital
        total_intereses += interes
        cronograma.append(Cuota(
            numero=i, fecha_pago=fecha_pago,
            monto_cuota=round(cuota_fija, 2),
            capital=round(capital, 2),
            interes=round(interes, 2),
            saldo_pendiente=round(max(saldo, 0), 2)
        ))

    return SimularResponse(
        tea=tea, tem=round(TEM, 8),
        cuota_fija=round(cuota_fija, 2),
        total_intereses=round(total_intereses, 2),
        total_pagar=round(monto + total_intereses, 2),
        cronograma=cronograma
    )


def calcular_cronograma(req: SimularRequest) -> SimularResponse:
    TEA = 40.92 if req.con_desgravamen else 43.92
    return _calcular_cronograma(req.monto, req.plazo_meses, TEA)


def calcular_cronograma_educativo(monto: float, plazo: int) -> SimularEducativoResponse:
    TEA = 43.92
    result = _calcular_cronograma(monto, plazo, TEA)
    total_pagar = result.total_pagar
    if total_pagar > 0:
        pct_capital = round(monto / total_pagar * 100, 1)
        pct_interes = round(result.total_intereses / total_pagar * 100, 1)
    else:
        pct_capital = 100.0
        pct_interes = 0.0
    return SimularEducativoResponse(
        tea=result.tea, tem=result.tem,
        cuota_fija=result.cuota_fija,
        total_intereses=result.total_intereses,
        total_pagar=result.total_pagar,
        porcentaje_capital=pct_capital,
        porcentaje_interes=pct_interes,
        cronograma=result.cronograma
    )


def validar_capacidad_pago(ingresos: float, costos: float, gastos: float, cuota: float) -> dict:
    excedente = ingresos - costos - gastos
    cobertura = excedente / cuota * 100 if cuota > 0 else 0
    suficiente = cobertura >= 130
    return {
        "excedente_familiar": round(excedente, 2),
        "cobertura_porcentaje": round(cobertura, 1),
        "suficiente": suficiente,
        "mensaje": "Capacidad de pago suficiente" if suficiente else "Capacidad de pago insuficiente - El excedente debe cubrir al menos el 130% de la cuota"
    }
