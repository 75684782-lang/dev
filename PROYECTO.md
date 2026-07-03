# CRAC Incasur - Resumen del Proyecto

## Apps
| App | Ruta | APK |
|-----|------|-----|
| Portal Gerencia (Web) | `portal_gerencia/` | https://portalgerencia-three.vercel.app |
| App Fuerza de Ventas | `appbanco_incasur_ventas/` | `CRAC_Incasur_Ventas.apk` |
| App Cliente | `appbanco_incasur_cliente/` | `CRAC_Incasur_Cliente.apk` |
| Backend Core | `backend_core/` | FastAPI puerto 8003 |

## Deploy Web (Vercel)
```powershell
cd portal_gerencia
vercel --prod
```

## Build APKs
```powershell
$env:JAVA_HOME = "C:\Program Files\Android\openjdk\jdk-21.0.8"
cd appbanco_incasur_ventas; flutter build apk --debug
cd ../appbanco_incasur_cliente; flutter build apk --debug
```

## Supabase
- URL: `https://jznjjmwzctpclilemryj.supabase.co`
- Anon Key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6bmpqbXd6Y3RwY2xpbGVtcnlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgxODEyMDUsImV4cCI6MjA5Mzc1NzIwNX0.mc9w-E40YEQfXsoTpmwHLWskxoIV8PTlg8Q_28a5cus`
- Service Key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6bmpqbXd6Y3RwY2xpbGVtcnlqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3ODE4MTIwNSwiZXhwIjoyMDkzNzU3MjA1fQ.jCkFPXVo7Uz2-VLsk6muzlljTDUF604T__lzcVvBrSc`

## Auth - Portal Web
- Login: DNI + contraseña (convierte a `{dni}@incasur.app` internamente)
- Usuarios: `99999999/test1234` (admin), `22222222/test1234` (supervisor), `11111111/test1234` (operador)

## Colores Corporativos
| Color | Hex |
|-------|-----|
| Azul petróleo | `#0E6481` |
| Azul oscuro | `#0A4D63` |
| Amarillo | `#EAEA00` |

## Assets
- `logo.png` - Logo empresa
- `fondologin.png` - Fondo login apps
- `fondopara la paginaweb.png` - Fondo portal web

## Backend
- FastAPI mock corriendo en puerto 8003
- Test: `cd backend_core; python -m pytest test_30_casos.py -v`

## Flutter
- SDK: `D:\flutter\flutter\bin\flutter.bat`
- Java: `C:\Program Files\Android\openjdk\jdk-21.0.8`
- Android SDK: configurado via `flutter config --android-sdk`
