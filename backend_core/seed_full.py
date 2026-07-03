"""
Seed completo para CRAC Incasur - Schema A
Crea: 3 agencias, 30 asesores (con Auth users), 600 clientes,
cartera diaria, y 30 solicitudes de credito.
"""
import os, sys, json, uuid
import bcrypt
import requests

SUPABASE_URL = "https://jznjjmwzctpclilemryj.supabase.co"
SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6bmpqbXd6Y3RwY2xpbGVtcnlqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3ODE4MTIwNSwiZXhwIjoyMDkzNzU3MjA1fQ.jCkFPXVo7Uz2-VLsk6muzlljTDUF604T__lzcVvBrSc"
MGMT_TOKEN = os.environ.get("SUPABASE_MGMT_TOKEN", "")
PASS = "1234"
BATCH = 50

SQL_HEADERS = {"Authorization": f"Bearer {MGMT_TOKEN}", "Content-Type": "application/json"}
AUTH_HEADERS = {"apikey": SERVICE_KEY, "Authorization": f"Bearer {SERVICE_KEY}", "Content-Type": "application/json"}

def sql(query):
    url = "https://api.supabase.com/v1/projects/jznjjmwzctpclilemryj/database/query"
    r = requests.post(url, headers=SQL_HEADERS, json={"query": query})
    if r.status_code not in (200, 201):
        raise RuntimeError(f"SQL error ({r.status_code}): {r.text[:300]}")
    return r.json()

def auth_user(dni, rol):
    email = f"{dni}@incasur.app"
    r = requests.get(f"{SUPABASE_URL}/auth/v1/admin/users", headers=AUTH_HEADERS, params={"filter": email})
    if r.status_code == 200 and r.json().get("users"):
        return r.json()["users"][0]["id"]
    r = requests.post(f"{SUPABASE_URL}/auth/v1/admin/users", headers=AUTH_HEADERS, json={
        "email": email, "password": PASS, "email_confirm": True,
        "user_metadata": {"dni": dni, "rol": rol},
    })
    if r.status_code not in (200, 201):
        print(f"  WARN: Auth {dni} failed: {r.text[:80]}")
        return None
    return r.json()["id"]

# === 1. AGENCIAS ===
print("=== 1. AGENCIAS ===")
sql("""
INSERT INTO agencias (nombre, region, lat, lng, activa) VALUES
    ('Agencia Norte', 'Cusco', -13.5320, -71.9675, TRUE),
    ('Agencia Centro', 'Cusco', -13.5180, -71.9780, TRUE),
    ('Agencia Sur', 'Cusco', -13.5450, -71.9550, TRUE)
ON CONFLICT DO NOTHING;
""")
ag_row = sql("SELECT id, nombre FROM agencias ORDER BY nombre;")
ag_ids = {r["nombre"]: r["id"] for r in ag_row}
print(f"  {len(ag_ids)} agencias OK")

# === 2. ASESORES (Auth + asesores_negocio) ===
print("\n=== 2. ASESORES (30) ===")
hash_pw = bcrypt.hashpw(PASS.encode(), bcrypt.gensalt()).decode()

nombres = ["Carlos","Lucia","Jorge","Rosa","Miguel","Elena","Victor","Sofia","Raul","Carmen",
           "Pedro","Ana","Luis","Diana","Oscar","Patricia","Hector","Gloria","Javier","Nadia",
           "Fernando","Monica","Cesar","Veronica","Daniel","Karina","Renato","Ingrid","Alex","Yesenia"]
apellidos = ["Ramirez","Flores","Huaman","Apaza","Ccahua","Quispe","Mamani","Condori","Vargas","Soto",
             "Gutierrez","Castro","Meza","Aliaga","Baldeon","Riveros","Caceres","Espinoza","Pariona","Lopez",
             "Salazar","Orihuela","Bravo","Hinostroza","Maravi","Poma","Chuquillanqui","Ramos","Quispe","Huaroc"]

total = 0
ase_rows = []
for i in range(30):
    dni = f"{40000001 + i:08d}"
    cod = f"{i+1:04d}"
    ag_key = ["Agencia Norte", "Agencia Centro", "Agencia Sur"][i//10]
    perfil = "supervisor" if i % 10 == 0 else "operador"
    uid = auth_user(dni, perfil)
    if not uid:
        continue
    sql(f"""
    INSERT INTO asesores_negocio (user_id, codigo_empleado, clave_hash, nombres, apellidos, agencia_id, perfil, activo)
    VALUES ('{uid}', '{cod}', '{hash_pw}', '{nombres[i]}', '{apellidos[i]}', '{ag_ids[ag_key]}', '{perfil}', TRUE)
    ON CONFLICT (codigo_empleado) DO UPDATE SET user_id='{uid}', nombres='{nombres[i]}', apellidos='{apellidos[i]}';
    """)
    total += 1
    r = sql(f"SELECT id FROM asesores_negocio WHERE codigo_empleado = '{cod}';")
    if r:
        ase_rows.append(r[0]["id"])
print(f"  {total} asesores OK")

if not ase_rows:
    ase_rows = [r["id"] for r in sql("SELECT id FROM asesores_negocio ORDER BY codigo_empleado;")]

# === 3. CLIENTES (600 en tabla clientes + 600 en clientes_ficha) ===
print("\n=== 3. CLIENTES (600) ===")
cf_ids = []
for b in range(1, 601, BATCH):
    end = min(b + BATCH - 1, 600)
    vals_u = []
    vals_f = []
    vals_c = []
    for n in range(b, end + 1):
        uid = str(uuid.uuid4())
        dni_cli = f"{40000030 + n:08d}"
        noms = ["Maria","Jose","Rosa","Pedro","Lucia","Juan","Carmen","Luis","Ana","Cesar",
                "Sonia","Walter","Yolanda","Marco","Elena","Raul","Gladys","Hugo","Nilda","Edwin"][n % 20]
        apes = ["Quispe","Mamani","Condori","Apaza","Huaman","Vargas","Flores","Ccahua","Soto","Ramos",
                "Inga","Ñahui","Lazo","Huanca","Taipe","Pariona","Aliaga","Meza","Poma","Maravi"][n % 20]
        neg = ["Bodega","Restaurante","Ferreteria","Farmacia","Peluqueria","Taller","Sastreria","Libreria","Carpinteria","Polleria"][n % 10]
        tel = f"9{(80000000 + n) % 1000000000:09d}"
        ing = 1500 + (n * 137) % 3500
        vals_u.append(f"('{uid}', '{dni_cli}', '{hash_pw}', 'cliente')")
        vals_f.append(f"('{uid}', '{uid}', '{noms} {apes}', '{tel}', '{neg} de {noms}', {18 + n % 48}, {ing}, {int(ing*0.5)}, {round(-13.53 + (n*0.0007) % 0.05, 7)}, {round(-71.97 + (n*0.0005) % 0.04, 7)})")
        vals_c.append(f"('{dni_cli}', 'DNI', '{noms}', '{apes}', '{tel}', '{neg}', '{neg} de {noms}', {18 + n % 48}, {ing}, 'Normal')")
    sql(f"""
    INSERT INTO usuarios (id, dni, clave_hash, rol)
    VALUES {','.join(vals_u)}
    ON CONFLICT (dni) DO NOTHING;
    """)
    sql(f"""
    INSERT INTO clientes_ficha (id, usuario_id, nombre_completo, telefono, negocio_nombre, antiguedad_meses, ingresos_estimados, gastos_estimados, ubicacion_lat, ubicacion_lng)
    VALUES {','.join(vals_f)};
    """)
    sql(f"""
    INSERT INTO clientes (numero_documento, tipo_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, calificacion_sbs)
    VALUES {','.join(vals_c)}
    ON CONFLICT (numero_documento) DO NOTHING;
    """)
    print(f"  Clientes {b}-{end} OK")

# Get all clientes_ficha IDs
cf_ids = [r["id"] for r in sql("SELECT id FROM clientes_ficha ORDER BY id LIMIT 600;")]

# === 4. CARTERA DIARIA ===
print("\n=== 4. CARTERA DIARIA ===")
for idx, ase_id in enumerate(ase_rows):
    start = idx * 20
    cli_batch = cf_ids[start:start+20]
    for pos, cli_id in enumerate(cli_batch):
        if pos < 12:
            t, p = "RENOVACION", "normal"
        elif pos < 17:
            t, p = "SEGUIMIENTO", "alta"
        else:
            t, p = "RECUPERACION_MORA", "alta"
        sql(f"""
        INSERT INTO cartera_diaria (asesor_id, cliente_id, tipo_gestion, prioridad, visitado, asesor_negocio_id)
        VALUES ('{ase_id}', '{cli_id}', '{t}', '{p}', FALSE, '{ase_id}')
        ON CONFLICT DO NOTHING;
        """)
    print(f"  Cartera asesor {idx+1} ({len(cli_batch)} cltes) OK")

# === 5. SOLICITUDES (30) ===
print("\n=== 5. SOLICITUDES CREDITO (30) ===")
from datetime import date, timedelta
today = date.today()
for i in range(30):
    cli_id = cf_ids[i]      # Cliente 0..29
    ase_id = ase_rows[i]    # Asesor i
    age_id = ag_ids[["Agencia Norte", "Agencia Centro", "Agencia Sur"][i//10]]
    montos = [3000, 5000, 8000, 10000, 15000, 20000]
    monto = montos[i % 6]
    plazos = [6, 12, 18, 24]
    plazo = plazos[i % 4]
    tea = round(35 + (i * 7) % 21, 2)
    estados = ["enviado","en_evaluacion","aprobado","borrador","recibido_comite","aprobado","condicionado"]
    estado = estados[i % 7]
    creado = (today - timedelta(days=i % 5)).isoformat()
    exp = f"EXP-2026-{i+1:04d}"
    sql(f"""
    INSERT INTO solicitudes_credito (numero_expediente, asesor_id, cliente_id, agencia_id, monto_solicitado, plazo_meses, tea, con_desgravamen, estado, creado_en)
    VALUES ('{exp}', '{ase_id}', '{cli_id}', '{age_id}', {monto}, {plazo}, {tea}, TRUE, '{estado}', '{creado}')
    ON CONFLICT (numero_expediente) DO NOTHING;
    """)
    print(f"  {exp} ({estado}) OK")

print("\n=== SEED COMPLETADO ===")
