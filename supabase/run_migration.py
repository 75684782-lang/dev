"""
Ejecuta la migración SQL de auth en Supabase via conexión directa PostgreSQL.
"""
import os
import psycopg2

# Datos de conexión a Supabase PostgreSQL
# Obtén estos datos de: Project Settings > Database > Connection string
DB_HOST = "aws-0-us-west-1.pooler.supabase.com"
DB_PORT = 6543
DB_NAME = "postgres"
DB_USER = "postgres.jznjjmwzctpclilemryj"
DB_PASSWORD = "incasur-secret-dev-change-in-production"

migration_path = os.path.join(os.path.dirname(__file__), "migrations", "001_auth_schema.sql")

with open(migration_path, "r", encoding="utf-8") as f:
    sql = f.read()

print("Conectando a Supabase PostgreSQL...")
conn = psycopg2.connect(
    host=DB_HOST,
    port=DB_PORT,
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    sslmode="require",
)
conn.autocommit = True
cur = conn.cursor()

print("Ejecutando migración...")
try:
    cur.execute(sql)
    print("✓ Migración ejecutada exitosamente")
except Exception as e:
    print(f"Error: {e}")
    print("\nSi falla, ejecuta manualmente en el SQL Editor del Dashboard:")
    print(f"1. Abre: https://supabase.com/dashboard/project/jznjjmwzctpclilemryj/sql/new")
    print(f"2. Copia y pega el contenido de: {migration_path}")
    print(f"3. Haz clic en 'Run'")
finally:
    cur.close()
    conn.close()
