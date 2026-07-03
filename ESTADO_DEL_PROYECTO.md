# CRAC Incasur — Estado del Proyecto

> Fecha: 25/06/2026 | Backend corriendo en http://localhost:8003  
> Supabase: https://jznjjmwzctpclilemryj.supabase.co

---

## ✅ LO QUE YA TENEMOS

### FASE 1 — Backend (FastAPI + Supabase)

| Componente | Estado | Detalle |
|---|---|---|
| `schema.sql` | ✅ Creado y ejecutado | 6 tablas + RLS + índices |
| `seed.sql` | ✅ Creado y ejecutado | 2 casos: Anaximandro Quispe + Eulalia Mamani |
| `.env` | ✅ Configurado | SUPABASE_URL + anon_key + service_role |
| `app/db.py` | ✅ Conexión real | Cliente Supabase conectado y probado |
| `auth.py` | ✅ Conectado a DB real | Login bcrypt + Registro con insert en usuarios + clientes_ficha |
| `cartera.py` | ✅ Conectado a DB real | GET /cartera, GET /ruta, POST /checkin con GPS |
| `solicitudes.py` | ✅ Conectado a DB real | CRUD solicitudes, simulación, desembolso con cronograma |
| `cronograma.py` | ✅ Conectado a DB real | GET por expediente desde tabla cronogramas |
| `sync.py` | ✅ Endpoint mock | POST /sync_outbox para sincronización offline |
| `financiero.py` | ✅ Funcional | Amortización francesa (TEA 40.92%/43.92%), excedente 130% |
| `middleware/auth.py` | ✅ Creado | JWT real con HS256, expiración 24h, dependencia `get_current_user` |
| `upload.py` | ✅ Creado | POST /upload/{expediente} + inicializar bucket, subida a Supabase Storage |
| `main.py` | ✅ En puerto 8003 | CORS abierto, todos los routers incluidos |

### FASE 2 — App Cliente (Flutter)

| Componente | Estado | Detalle |
|---|---|---|
| `pubspec.yaml` | ✅ Creado | Dependencias: riverpod, supabase, go_router, http |
| `lib/main.dart` | ✅ Creado | ProviderScope + MaterialApp.router |
| `theme.dart` | ✅ Creado | Colores corporativos azul/verde/dorado |
| `LoginScreen` | ✅ Creado | Validación DNI + contraseña, enlace a registro |
| `RegistroScreen` | ✅ Creado | Auto-registro con validación biométrica simulada |
| `DashboardScreen` | ✅ Creado | Saldo, créditos activos, acciones rápidas, notificación push |
| `SolicitudScreen` | ✅ Creado | Formulario: monto, plazo, destino, garantía, desgravamen |
| `SimuladorEducativoScreen` | ✅ Creado | Gráfico donut capital vs interés, TEA 43.92% |
| `SeguimientoScreen` | ✅ Creado | Línea de tiempo: Recibido → Evaluación → Aprobado → Desembolsado |
| `CronogramaScreen` | ✅ Creado | Tabla de cuotas fijas |
| `router_config.dart` | ✅ Creado | 7 rutas configuradas |
| `auth_viewmodel.dart` | ✅ Creado | Riverpod ChangeNotifier |
| `solicitud_viewmodel.dart` | ✅ Creado | Carga, simula y envía solicitudes |

### FASE 3 — App Ventas (Flutter)

| Componente | Estado | Detalle |
|---|---|---|
| `pubspec.yaml` | ✅ Creado | Riverpod, supabase, isar, geolocator, signature, connectivity |
| `lib/main.dart` | ✅ Creado | Punto de entrada |
| `theme.dart` | ✅ Creado | Colores + naranja y rojo para prioridades |
| `CarteraScreen` | ✅ Creado | Lista priorizada, filtros, indicador visitados |
| `FichaClienteScreen` | ✅ Creado | Check-in GPS, captura de documentos (RUC/Licencia/Boletas/Firma) |
| `StepperScreen` | ✅ Creado | 4 pasos: Datos → Financiero → Simulador → Firma |
| | | Cálculo automático de excedente familiar |
| | | Validación 130% de cobertura |
| | | Evaluación SBS (inhabilitado por dígito) |
| `sync_outbox_item.dart` | ✅ Creado | Modelo para cola offline |
| `offline_sync_service.dart` | ✅ Actualizado | Persistencia en archivo JSON via path_provider, auto-sync cada 30s |
| `local_persistence_service.dart` | ✅ Creado | Carga/guarda outbox en JSON en directorio de documentos |

### FASE 4 — Portal Web (React + Vite + Tailwind)

| Componente | Estado | Detalle |
|---|---|---|
| `package.json` | ✅ Creado | React, axios, recharts, leaflet, lucide-react |
| `vite.config.ts` | ✅ Creado | Puerto 5173 |
| `tailwind.config.js` | ✅ Creado | Colores personalizados incasur |
| `Layout.tsx` | ✅ Creado | Sidebar con 4 secciones |
| `MapaGPS.tsx` | ✅ Creado | Panel de control geográfico con visitas y pendientes |
| `ComiteCreditos.tsx` | ✅ Creado | Bandeja, panel de revisión, aprobar/rechazar/condicionar |
| `Desembolsos.tsx` | ✅ Creado | Ejecutar desembolso, generación de cronograma |
| `DashboardAnalitico.tsx` | ✅ Creado | 4 KPIs, evolución mensual, montos, distribución, 6 indicadores |
| `api.ts` | ✅ Actualizado | Interceptor 401, headers Authorization JWT en cada request |
| `AuthContext.tsx` | ✅ Creado | Auth context con login/logout, persistencia en localStorage |
| `LoginPage.tsx` | ✅ Creado | Formulario login con DNI + contraseña, ruta protegida |

---

## ❌ LO QUE FALTA

### Prioridad Alta — Para que funcione end-to-end

| # | Tarea | Estado | Detalle |
|---|---|---|---|---|
| 1 | **Inicializar proyectos Flutter** | ✅ | `flutter pub get` resuelto en ambas apps |
| 2 | **Inicializar proyecto React** | ✅ | `npm install` ejecutado, build exitoso |
| 3 | **Auth JWT real** | ✅ | `app/middleware/auth.py` — JWT HS256, expiración 24h, `get_current_user` en endpoints protegidos |
| 4 | **Supabase Auth** | 📋 Pendiente | Configurar Authentication en dashboard de Supabase manualmente |
| 5 | **Asignar asesor_id real** | ✅ | `solicitudes.py` extrae `current_user["user_id"]` del JWT |
| 6 | **Subida de fotos a Storage** | ✅ | `app/routers/upload.py` — POST /upload/{expediente}, bucket `expedientes` |
| 7 | **Persistencia offline real** | ✅ | `local_persistence_service.dart` — JSON persistente via path_provider |

### Mejoras adicionales implementadas

| # | Mejora | Detalle |
|---|---|---|
| A | **Frontend Flutter cliente con JWT** | `auth_repository.dart` ahora llama a FastAPI `/auth/login` y `/auth/registro` (no más Supabase Functions) |
| B | **SolicitudRepository con token** | Pasa `Authorization: Bearer {token}` en cada request |
| C | **Portal React con auth** | `AuthContext.tsx` + `LoginPage.tsx` — login/logout con JWT, persistencia en localStorage |
| D | **Interceptor 401 en portal** | api.ts redirige automáticamente a `/login` si el token expira |
| E | **Protección de rutas** | Todos los endpoints de solicitudes, cartera y cronograma requieren autenticación JWT |

### Prioridad Media — Experiencia completa

| # | Tarea | Detalle |
|---|---|---|
| 8 | **Supabase Realtime** | Suscribir apps a cambios en `solicitudes_credito` para notificaciones en vivo |
| 9 | **Notificaciones push** | Firebase Cloud Messaging en apps Flutter |
| 10 | **Mapa interactivo real** | Integrar react-leaflet con tiles de OpenStreetMap en portal |
| 11 | **Firma digital funcional** | Integrar paquete `signature` (hoy es placeholder visual) |
| 12 | **Validación biométrica real** | Reemplazar simulación con cámara + ML Kit |
| 13 | **docker-compose.yml** | Orquestar backend + portal + supabase local |

### Prioridad Baja — Pulido

| # | Tarea | Detalle |
|---|---|---|
| 14 | **Tests unitarios** | pytest para backend, flutter_test para apps |
| 15 | **Logs y monitoreo** | structlog, prometheus o similar |
| 16 | **Manejo de errores** | Snackbars + retry + timeouts consistentes en todas las apps |
| 17 | **CI/CD** | GitHub Actions para deploy automático |
| 18 | **Internacionalización** | Soporte quechua/español |

---

## 📊 MATRIZ DE COMUNICACIÓN ENTRE APPS

```
App Cliente ──POST /solicitudes──➔  FastAPI ──INSERT──➔  Supabase
                                        │
App Ventas  ──GET /cartera──────────➔  FastAPI ──SELECT──➔  Supabase
App Ventas  ──POST /checkin─────────➔  FastAPI ──UPDATE──➔  Supabase
App Ventas  ──POST /sync_outbox─────➔  FastAPI ──INSERT──➔  Supabase
                                        │
Portal Web  ──GET /solicitudes──────➔  FastAPI ──SELECT──➔  Supabase
Portal Web  ──PATCH .../estado──────➔  FastAPI ──UPDATE──➔  Supabase
Portal Web  ──POST .../desembolsar──➔  FastAPI ──INSERT cronogramas──➔  Supabase
```

### Estados del crédito (ciclo de vida)
```
borrador → enviado → en_evaluacion → aprobado → desembolsado
                                      → condicionado
                                      → rechazado
```

---

## 🚀 CÓMO LEVANTAR TODO

### Backend (ya funcionando)
```bash
cd backend_core
python -m uvicorn app.main:app --port 8003 --reload
```

### Probar endpoints
```bash
# Login (devuelve JWT real)
curl -s -X POST http://localhost:8003/auth/login -H "Content-Type: application/json" -d "{\"dni\":\"11111111\",\"clave\":\"test1234\"}"
# → access_token, rol, usuario_id

# Guardar token en variable (PowerShell)
$token = (curl -s -X POST http://localhost:8003/auth/login -H "Content-Type: application/json" -d '{\"dni\":\"11111111\",\"clave\":\"test1234\"}' | ConvertFrom-Json).access_token

# Listar solicitudes (requiere token)
curl http://localhost:8003/solicitudes/ -H "Authorization: Bearer $token"

# Simular crédito (público, no requiere token)
curl -X POST http://localhost:8003/solicitudes/simular -H "Content-Type: application/json" -d "{\"monto\":5000,\"plazo_meses\":12}"

# Ver cronograma
curl http://localhost:8003/cronograma/EXP-2026-0001 -H "Authorization: Bearer $token"

# Subir archivo (requiere token)
curl -X POST http://localhost:8003/upload/EXP-2026-0001 -H "Authorization: Bearer $token" -F "tipo=ruc" -F "file=@documento.pdf"

# Inicializar bucket (solo admin/supervisor)
curl -X POST http://localhost:8003/upload/inicializar-bucket -H "Authorization: Bearer $token"
```

### Portal Web
```bash
cd portal_gerencia
npm install
npm run dev
```

### Apps Flutter
```bash
cd appbanco_incasur_cliente
flutter create --project-name appbanco_incasur_cliente .
flutter pub get
flutter run

cd appbanco_incasur_ventas
flutter create --project-name appbanco_incasur_ventas .
flutter pub get
flutter run
```

---

> Creado para el proyecto universitario CRAC Incasur  
> Backend: Python FastAPI + Supabase PostgreSQL  
> Mobile: Flutter + Riverpod  
> Web: React + Vite + Tailwind  
