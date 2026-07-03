from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import auth, cartera, solicitudes, cronograma, sync, upload, buro, clientes

app = FastAPI(
    title="CRAC Incasur API",
    description="Backend del ecosistema de microfinanzas",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(cartera.router)
app.include_router(solicitudes.router)
app.include_router(cronograma.router)
app.include_router(sync.router)
app.include_router(upload.router)
app.include_router(buro.router)
app.include_router(clientes.router)


@app.get("/health")
async def health():
    return {"status": "ok", "version": "1.0.0"}
