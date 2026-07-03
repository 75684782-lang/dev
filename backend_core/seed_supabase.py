"""
Seed data para Supabase usando service_role key.
Crea Auth users en Supabase Authentication y usa sus mismos UIDs
en la tabla `usuarios` para que RLS funcione correctamente.
"""
import os
import sys
import bcrypt
import requests
from datetime import date, timedelta

sys.path.insert(0, os.path.dirname(__file__))
from dotenv import load_dotenv
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY")
PASS = "test1234"

from supabase import create_client

supabase = create_client(SUPABASE_URL, SERVICE_KEY)

AUTH_HEADERS = {
    "apikey": SERVICE_KEY,
    "Authorization": f"Bearer {SERVICE_KEY}",
    "Content-Type": "application/json",
}


def _get_or_create_auth_user(dni: str, rol: str) -> str:
    """Obtiene el Auth UID de un usuario en Supabase Auth, o lo crea si no existe."""
    email = f"{dni}@incasur.app"

    # Buscar usuario existente por email
    resp = requests.get(
        f"{SUPABASE_URL}/auth/v1/admin/users",
        headers=AUTH_HEADERS,
        params={"filter": email},
    )
    if resp.status_code == 200:
        users = resp.json().get("users", [])
        if users:
            uid = users[0]["id"]
            print(f"  {dni} ({rol}) - Auth user EXISTS (id={uid[:8]}...)")
            return uid

    # Crear Auth user
    resp = requests.post(
        f"{SUPABASE_URL}/auth/v1/admin/users",
        headers=AUTH_HEADERS,
        json={
            "email": email,
            "password": PASS,
            "email_confirm": True,
            "user_metadata": {"dni": dni, "rol": rol},
        },
    )
    if resp.status_code not in (200, 201):
        print(f"  ERROR creando Auth user {dni}: {resp.status_code} {resp.text}")
        sys.exit(1)

    uid = resp.json()["id"]
    print(f"  {dni} ({rol}) - Auth user CREATED (id={uid[:8]}...)")
    return uid


# ---- 1. Crear Auth users y sincronizar con tabla usuarios ----
print("=== Creando/verificando Auth users ===")
clave_hash = bcrypt.hashpw(PASS.encode(), bcrypt.gensalt()).decode()
users_data = [
    ("12345678", "cliente"),
    ("87654321", "cliente"),
    ("11111111", "operador"),
    ("22222222", "supervisor"),
    ("99999999", "administrador"),
]

user_ids = {}
for dni, rol in users_data:
    auth_uid = _get_or_create_auth_user(dni, rol)

    existing = supabase.table("usuarios").select("id").eq("dni", dni).execute()
    if existing.data:
        old_id = existing.data[0]["id"]
        if old_id == auth_uid:
            supabase.table("usuarios").update({"rol": rol, "clave_hash": clave_hash}).eq("id", auth_uid).execute()
            print(f"  {dni} ({rol}) - OK (UID match)")
        else:
            # Migrar FK references al nuevo Auth UID, luego reemplazar el row
            supabase.table("clientes_ficha").update({"usuario_id": auth_uid}).eq("usuario_id", old_id).execute()
            supabase.table("cartera_diaria").update({"asesor_id": auth_uid}).eq("asesor_id", old_id).execute()
            supabase.table("solicitudes_credito").update({"asesor_id": auth_uid}).eq("asesor_id", old_id).execute()
            supabase.table("usuarios").delete().eq("id", old_id).execute()
            supabase.table("usuarios").insert({
                "id": auth_uid, "dni": dni, "clave_hash": clave_hash, "rol": rol,
            }).execute()
            print(f"  {dni} ({rol}) - MIGRADO ({old_id[:8]}... -> {auth_uid[:8]}...)")
    else:
        supabase.table("usuarios").insert({
            "id": auth_uid, "dni": dni, "clave_hash": clave_hash, "rol": rol,
        }).execute()
        print(f"  {dni} ({rol}) - CREADO con Auth UID")

    user_ids[dni] = auth_uid

# ---- 2. Clientes_ficha ----
print("\n=== Verificando clientes_ficha ===")
clientes_seed = [
    ("12345678", "Anaximandro Quispe Huamán", "987654321", "Bodega Don Anaximandro", 48, 3500.0, 1800.0, -13.5320, -71.9675),
    ("87654321", "Eulalia Mamani Condori", "976543210", "Pollería La Sabrosita", 18, 2800.0, 1500.0, -13.5250, -71.9720),
]
ficha_ids = {}
for dni, nombre, tel, neg, ant, ing, gas, lat, lng in clientes_seed:
    existing = supabase.table("clientes_ficha").select("id").eq("usuario_id", user_ids[dni]).execute()
    if existing.data:
        ficha_ids[dni] = existing.data[0]["id"]
        print(f"  {nombre} - OK")
    else:
        r = supabase.table("clientes_ficha").insert({
            "usuario_id": user_ids[dni], "nombre_completo": nombre, "telefono": tel,
            "negocio_nombre": neg, "antiguedad_meses": ant, "ingresos_estimados": ing,
            "gastos_estimados": gas, "ubicacion_lat": lat, "ubicacion_lng": lng,
        }).execute()
        ficha_ids[dni] = r.data[0]["id"]
        print(f"  {nombre} - CREADO")

# ---- 3. Cartera diaria ----
print("\n=== Verificando cartera_diaria ===")
if ficha_ids:
    for dni, tipo, prio in [("12345678", "RENOVACION", "ALTA"), ("87654321", "NUEVA_SOLICITUD", "MEDIA")]:
        existing = supabase.table("cartera_diaria").select("id").eq("asesor_id", user_ids["11111111"]).eq("cliente_id", ficha_ids[dni]).eq("tipo_gestion", tipo).execute()
        if not existing.data:
            supabase.table("cartera_diaria").insert({
                "asesor_id": user_ids["11111111"], "cliente_id": ficha_ids[dni],
                "tipo_gestion": tipo, "prioridad": prio, "fecha_asignacion": date.today().isoformat(),
            }).execute()
            print(f"  Cartera {tipo} - CREADO")
        else:
            print(f"  Cartera {tipo} - OK")

# ---- 4. Solicitudes de crédito ----
print("\n=== Verificando solicitudes_credito ===")
for exp, dni, monto, plazo, tea_val, con_desg, gar, dest, estado, dias_atras in [
    ("EXP-2026-0001", "12345678", 5000.0, 12, 43.92, True, "Garantía personal", "Compra de mercadería", "enviado", 2),
    ("EXP-2026-0002", "87654321", 3000.0, 8, 40.92, True, "Prenda comercial", "Equipamiento de cocina", "en_evaluacion", 1),
]:
    existing = supabase.table("solicitudes_credito").select("id").eq("numero_expediente", exp).execute()
    if existing.data:
        print(f"  {exp} - OK")
    else:
        creado = (date.today() - timedelta(days=dias_atras)).isoformat()
        r = supabase.table("solicitudes_credito").insert({
            "numero_expediente": exp, "cliente_id": ficha_ids[dni], "asesor_id": user_ids["11111111"],
            "monto_solicitado": monto, "plazo_meses": plazo, "tea": tea_val,
            "con_desgravamen": con_desg, "garantia": gar, "destino_credito": dest,
            "estado": estado, "creado_en": creado,
        }).execute()
        sid = r.data[0]["id"]
        print(f"  {exp} - CREADO")

        if exp == "EXP-2026-0001":
            tem = (1 + tea_val / 100) ** (1 / 12) - 1
            cuota = round(monto * (tem * (1 + tem) ** plazo) / ((1 + tem) ** plazo - 1), 2)
            saldo = monto
            fp = date.today() + timedelta(days=30)
            for i in range(1, plazo + 1):
                interes = round(saldo * tem, 2)
                capital = round(cuota - interes, 2)
                if i == plazo:
                    capital = round(saldo, 2)
                    cuota = round(capital + interes, 2)
                saldo = round(saldo - capital, 2)
                supabase.table("cronogramas").insert({
                    "solicitud_id": sid, "numero_cuota": i, "fecha_pago": fp.isoformat(),
                    "monto_cuota": cuota, "capital": capital, "interes": interes, "saldo_pendiente": saldo,
                }).execute()
                fp += timedelta(days=30)
            print(f"    Cronograma {plazo} cuotas generado")

# ---- 5. Semilla S11: agencias y asesores_negocio (App Fuerza Ventas) ----
print("\n=== S11: Verificando agencias ===")
agencias_data = [
    ("Agencia Cusco", "Cusco", -13.5320, -71.9675),
    ("Agencia Lima", "Lima", -12.0464, -77.0428),
]
agencia_ids = {}
for nombre, region, lat, lng in agencias_data:
    existing = supabase.table("agencias").select("id").eq("nombre", nombre).execute()
    if existing.data:
        agencia_ids[nombre] = existing.data[0]["id"]
        print(f"  {nombre} - OK")
    else:
        r = supabase.table("agencias").insert({
            "nombre": nombre, "region": region, "lat": lat, "lng": lng, "activa": True,
        }).execute()
        agencia_ids[nombre] = r.data[0]["id"]
        print(f"  {nombre} - CREADO")

print("\n=== S11: Verificando asesores_negocio ===")
# Crear Auth user para asesor FVentas
fv_auth_uid = _get_or_create_auth_user("11111111", "operador")
# También creamos auth user para supervisor
sup_auth_uid = _get_or_create_auth_user("22222222", "supervisor")

asesores_data = [
    ("OP001", fv_auth_uid, "Carlos", "Mendoza Ríos", agencia_ids["Agencia Cusco"], "operador"),
    ("SP001", sup_auth_uid, "Lucía", "Paredes Gómez", agencia_ids["Agencia Cusco"], "supervisor"),
]
asesor_negocio_ids = {}
for codigo, auth_uid, nombres, apellidos, agencia_id, perfil in asesores_data:
    existing = supabase.table("asesores_negocio").select("id").eq("codigo_empleado", codigo).execute()
    if existing.data:
        asesor_negocio_ids[codigo] = existing.data[0]["id"]
        print(f"  {codigo} ({nombres}) - OK")
    else:
        r = supabase.table("asesores_negocio").insert({
            "user_id": auth_uid, "codigo_empleado": codigo, "clave_hash": clave_hash,
            "nombres": nombres, "apellidos": apellidos, "agencia_id": agencia_id,
            "perfil": perfil, "activo": True,
        }).execute()
        asesor_negocio_ids[codigo] = r.data[0]["id"]
        print(f"  {codigo} ({nombres}) - CREADO")

# ---- 6. Asignar asesor_negocio_id en cartera_diaria existente ----
print("\n=== S11: Vinculando cartera_diaria con asesores_negocio ===")
op_id = asesor_negocio_ids.get("OP001")
if op_id:
    supabase.table("cartera_diaria").update({"asesor_negocio_id": op_id}).eq("asesor_id", fv_auth_uid).execute()
    print(f"  Carteras vinculadas a asesor_negocio OP001")

# Crear clientes en tabla S11
print("\n=== S11: Verificando tabla clientes (S11) ===")
for dni in ["12345678", "87654321"]:
    existing = supabase.table("clientes").select("id").eq("numero_documento", dni).execute()
    if not existing.data:
        nombres = "Anaximandro Quispe" if dni == "12345678" else "Eulalia Mamani"
        apellidos = "Huamán" if dni == "12345678" else "Condori"
        supabase.table("clientes").insert({
            "numero_documento": dni, "tipo_documento": "DNI",
            "nombres": nombres, "apellidos": apellidos,
            "telefono": "987654321", "tipo_negocio": "Comercio",
            "nombre_negocio": "Bodega Don Anaximandro" if dni == "12345678" else "Pollería La Sabrosita",
            "antiguedad_negocio_meses": 48, "ingresos_estimados": 3500.0,
            "calificacion_sbs": "Normal",
        }).execute()
        print(f"  Cliente S11 {dni} - CREADO")
    else:
        print(f"  Cliente S11 {dni} - OK")

print("\n Migración completada!")
for dni, rol in users_data:
    print(f"  DNI: {dni} / Clave: test1234 / Rol: {rol}")
for codigo, _, nombres, _, _, _ in asesores_data:
    print(f"  Código: {codigo} / Clave: test1234 / Asesor: {nombres}")
