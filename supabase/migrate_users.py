"""
Script de migración: mueve usuarios de la tabla `usuarios` a Supabase Auth.

Uso:
  python migrate_users.py

Requiere:
  - supabase-py: pip install supabase
  - Las credenciales en backend_core/.env
"""
import os
import sys
import hashlib
import base64
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend_core'))

from app.db import supabase as sb
from supabase import create_client

SUPABASE_URL = "https://jznjjmwzctpclilemryj.supabase.co"
SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6bmpqbXd6Y3RwY2xpbGVtcnlqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3ODE4MTIwNSwiZXhwIjoyMDkzNzU3MjA1fQ.jCkFPXVo7Uz2-VLsk6muzlljTDUF604T__lzcVvBrSc"

admin = create_client(SUPABASE_URL, SERVICE_KEY)


def migrate_users():
    """Migra todos los usuarios de la tabla `usuarios` a Supabase Auth."""
    result = sb.table("usuarios").select("*").execute()
    users = result.data

    for user in users:
        dni = user["dni"]
        email = f"{dni}@incasur.app"
        password = f"incasur{dni}"  # contraseña temporal
        rol = user["rol"]

        try:
            # Crear usuario en Supabase Auth via Admin API
            resp = admin.auth.admin.create_user({
                "email": email,
                "password": password,
                "email_confirm": True,
                "user_metadata": {
                    "dni": dni,
                    "rol": rol,
                }
            })
            auth_user = resp.user
            print(f"✓ {dni} ({email}) -> {auth_user.id}")

            # Actualizar la tabla usuarios para usar el ID de auth
            sb.table("usuarios").update({
                "id": auth_user.id,
                "email": email,
            }).eq("dni", dni).execute()

        except Exception as e:
            if "already exists" in str(e):
                print(f"~ {dni} ya existe en Auth, vinculando...")
                auth_users = admin.auth.admin.list_users()
                for au in auth_users:
                    if au.email == email:
                        sb.table("usuarios").update({
                            "id": au.id,
                            "email": email,
                        }).eq("dni", dni).execute()
                        break
            else:
                print(f"✗ {dni}: {e}")

    print("\nMigración completada.")
    print("Contraseñas temporales: incasur{DNI} (ej: incasur12345678)")


if __name__ == "__main__":
    migrate_users()
