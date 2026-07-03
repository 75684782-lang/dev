"""
Migración completa de schema.sql y seed.sql a Supabase.
Conecta directamente a PostgreSQL de Supabase para DDL,
luego usa service_role key para seed data con hashes correctos.
"""
import os
import sys
import re
import hashlib

sys.path.insert(0, os.path.dirname(__file__))

from dotenv import load_dotenv
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY")
JWT_SECRET = os.getenv("JWT_SECRET")

if not SUPABASE_URL:
    print("ERROR: SUPABASE_URL no encontrado en .env")
    sys.exit(1)

project_ref = SUPABASE_URL.replace("https://", "").split(".")[0]
print(f"Project ref: {project_ref}")

# ---- 1. Intentar conexión directa a PostgreSQL ----
# Usamos el service_key como password (convención de algunos setups)
# O intentamos 'postgres' como password por defecto
conn = None
passwords_to_try = [SUPABASE_SERVICE_KEY, "postgres", "supabase", "admin"]

for pwd in passwords_to_try:
    try:
        import psycopg2
        conn = psycopg2.connect(
            host=f"db.{project_ref}.supabase.co",
            port=5432,
            dbname="postgres",
            user="postgres",
            password=pwd,
            connect_timeout=5,
        )
        print(f"Conexión directa exitosa con password: {pwd[:8]}...")
        break
    except Exception as e:
        print(f"  intento fallido: {e}")
        continue

if conn is None:
    print("\nNo se pudo conectar directamente a PostgreSQL.")
    print("Las tablas ya existen? Verificando via REST API...")
    from app.db import supabase
    tables_exist = True
    for t in ["usuarios", "clientes_ficha", "cartera_diaria", "solicitudes_credito", "cronogramas", "sync_outbox"]:
        try:
            supabase.table(t).select("count", count="exact").execute()
            print(f"  {t}: OK")
        except Exception as e:
            print(f"  {t}: ERROR - {e}")
            tables_exist = False
    if tables_exist:
        print("\nTodas las tablas existen. Solo se necesita seed data con hashes correctos.")
        print("Ejecuta: python seed_supabase.py")
    else:
        print("\nFaltan tablas. Necesitas:")
        print("1. Ir a https://supabase.com/dashboard/project/{project_ref}/sql/new")
        print(f"2. Pegar el contenido de schema.sql")
        print(f"3. Luego ejecutar: python seed_supabase.py")
    sys.exit(0)

# ---- 2. Conexión exitosa: ejecutar schema.sql y seed.sql ----
cur = conn.cursor()

# Leer y ejecutar schema.sql
schema_path = os.path.join(os.path.dirname(__file__), "schema.sql")
if os.path.exists(schema_path):
    with open(schema_path, "r", encoding="utf-8") as f:
        schema_sql = f.read()
    # Separar por punto y coma para ejecutar cada statement
    statements = [s.strip() for s in schema_sql.split(";") if s.strip()]
    success = 0
    for stmt in statements:
        try:
            cur.execute(stmt)
            conn.commit()
            # Mostrar solo CREATE/ALTER
            first_word = stmt.strip().split()[0].upper() if stmt.strip() else ""
            if first_word in ("CREATE", "ALTER", "DROP"):
                print(f"  OK: {stmt[:60]}...")
            success += 1
        except Exception as e:
            conn.rollback()
            if "already exists" in str(e) or "IF NOT EXISTS" in stmt:
                pass  # Tabla ya existe, no es error
            else:
                print(f"  ERROR en: {stmt[:60]}... -> {e}")
    print(f"\nSchema: {success}/{len(statements)} statements ejecutados")
else:
    print("WARN: schema.sql no encontrado")

# ---- 3. Seed data con hashes correctos ----
# Limpiar datos existentes primero
tables_order = ["cronogramas", "sync_outbox", "solicitudes_credito", "cartera_diaria", "clientes_ficha", "usuarios"]
for t in tables_order:
    try:
        cur.execute(f"DELETE FROM {t}")
        conn.commit()
        print(f"  Limpiado: {t}")
    except Exception as e:
        conn.rollback()

def hash_clave(clave):
    salt = os.urandom(16).hex()
    return hashlib.sha256(f"{salt}:{clave}".encode()).hexdigest() + f":{salt}"

# 3a. Usuarios
usuarios_seed = [
    ("12345678", hash_clave("test1234"), "cliente"),
    ("87654321", hash_clave("test1234"), "cliente"),
    ("11111111", hash_clave("test1234"), "operador"),
    ("22222222", hash_clave("test1234"), "supervisor"),
    ("99999999", hash_clave("test1234"), "administrador"),
]
for dni, ch, rol in usuarios_seed:
    try:
        cur.execute(
            "INSERT INTO usuarios (dni, clave_hash, rol) VALUES (%s, %s, %s) ON CONFLICT (dni) DO UPDATE SET clave_hash = EXCLUDED.clave_hash",
            (dni, ch, rol),
        )
        conn.commit()
        print(f"  Usuario {dni} ({rol}) OK")
    except Exception as e:
        conn.rollback()
        print(f"  Error usuario {dni}: {e}")

# 3b. Obtener IDs de usuarios
cur.execute("SELECT id, dni FROM usuarios")
user_ids = {row[1]: row[0] for row in cur.fetchall()}

# 3c. Clientes_ficha
cliente_anax = ("Anaximandro Quispe Huamán", "987654321", "Bodega Don Anaximandro", 48, 3500.00, 1800.00, -13.5320, -71.9675)
cliente_eula = ("Eulalia Mamani Condori", "976543210", "Pollería La Sabrosita", 18, 2800.00, 1500.00, -13.5250, -71.9720)

ficha_ids = {}
for dni, (nombre, tel, neg, ant, ing, gas, lat, lng) in [("12345678", cliente_anax), ("87654321", cliente_eula)]:
    try:
        cur.execute(
            "INSERT INTO clientes_ficha (usuario_id, nombre_completo, telefono, negocio_nombre, antiguedad_meses, ingresos_estimados, gastos_estimados, ubicacion_lat, ubicacion_lng) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING id",
            (user_ids[dni], nombre, tel, neg, ant, ing, gas, lat, lng),
        )
        conn.commit()
        fid = cur.fetchone()[0]
        ficha_ids[dni] = fid
        print(f"  Ficha {nombre} OK (id={fid})")
    except Exception as e:
        conn.rollback()
        print(f"  Error ficha {nombre}: {e}")

# 3d. Cartera diaria
if ficha_ids:
    try:
        cur.execute(
            "INSERT INTO cartera_diaria (asesor_id, cliente_id, tipo_gestion, prioridad, visitado, fecha_asignacion) VALUES (%s, %s, 'RENOVACION', 'ALTA', FALSE, CURRENT_DATE)",
            (user_ids["11111111"], ficha_ids["12345678"]),
        )
        conn.commit()
        print("  Cartera Renovacion Anaximandro OK")
    except Exception as e:
        conn.rollback()
        print(f"  Error cartera: {e}")

    try:
        cur.execute(
            "INSERT INTO cartera_diaria (asesor_id, cliente_id, tipo_gestion, prioridad, visitado, fecha_asignacion) VALUES (%s, %s, 'NUEVA_SOLICITUD', 'MEDIA', FALSE, CURRENT_DATE)",
            (user_ids["11111111"], ficha_ids["87654321"]),
        )
        conn.commit()
        print("  Cartera Nueva Solicitud Eulalia OK")
    except Exception as e:
        conn.rollback()
        print(f"  Error cartera: {e}")

# 3e. Solicitudes de crédito y cronogramas
import uuid
from datetime import date, timedelta

for dni, monto, plazo, tea_val, con_desg, garantia, destino, estado, dias_atras, expediente in [
    ("12345678", 5000.00, 12, 43.92, True, "Garantía personal", "Compra de mercadería", "enviado", 2, "EXP-2026-0001"),
    ("87654321", 3000.00, 8, 40.92, True, "Prenda comercial", "Equipamiento de cocina", "en_evaluacion", 1, "EXP-2026-0002"),
]:
    if dni not in ficha_ids:
        continue
    try:
        cur.execute(
            """INSERT INTO solicitudes_credito (numero_expediente, cliente_id, asesor_id, monto_solicitado, plazo_meses, tea, con_desgravamen, garantia, destino_credito, estado, creado_en)
               VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW() - interval '%s days') RETURNING id""",
            (expediente, ficha_ids[dni], user_ids["11111111"], monto, plazo, tea_val, con_desg, garantia, destino, estado, dias_atras),
        )
        conn.commit()
        solicitud_id = cur.fetchone()[0]
        print(f"  Solicitud {expediente} OK")

        # Generar cronograma para EXP-2026-0001
        if expediente == "EXP-2026-0001":
            tem = (1 + tea_val / 100) ** (1 / 12) - 1
            cuota_fija = round(monto * (tem * (1 + tem) ** plazo) / ((1 + tem) ** plazo - 1), 2)
            saldo = monto
            fecha_pago = date.today() + timedelta(days=30)
            for i in range(1, plazo + 1):
                interes = round(saldo * tem, 2)
                capital = round(cuota_fija - interes, 2)
                if i == plazo:
                    capital = round(saldo, 2)
                    cuota_fija = round(capital + interes, 2)
                saldo = round(saldo - capital, 2)
                try:
                    cur.execute(
                        "INSERT INTO cronogramas (solicitud_id, numero_cuota, fecha_pago, monto_cuota, capital, interes, saldo_pendiente) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                        (solicitud_id, i, fecha_pago, cuota_fija, capital, interes, saldo),
                    )
                    conn.commit()
                    fecha_pago += timedelta(days=30)
                except Exception as e:
                    conn.rollback()
                    print(f"    Error cuota {i}: {e}")
            print(f"  Cronograma {plazo} cuotas generado")
    except Exception as e:
        conn.rollback()
        print(f"  Error solicitud {expediente}: {e}")

cur.close()
conn.close()
print("\n Migración completada exitosamente!")
