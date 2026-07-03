-- ============================================================
-- CRAC Incasur - bd_core_mobile (S11 + S9)
-- DDL para Supabase PostgreSQL con Row Level Security (RLS)
-- Compatible con App Cliente (homebanking) y App Fuerza Ventas
-- ============================================================

-- ==================== TABLAS EXISTENTES (App Cliente) ====================

-- 1. TABLA: usuarios (App Cliente - homebanking)
CREATE TABLE IF NOT EXISTS usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dni VARCHAR(8) UNIQUE NOT NULL CHECK (dni ~ '^\d{8}$'),
    clave_hash TEXT NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('operador', 'cliente', 'supervisor', 'administrador')),
    creado_en TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;

CREATE POLICY usuarios_select_policy ON usuarios
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY usuarios_insert_policy ON usuarios
    FOR INSERT WITH CHECK (auth.uid() = id);

-- 2. TABLA: clientes_ficha (App Cliente - homebanking)
CREATE TABLE IF NOT EXISTS clientes_ficha (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nombre_completo TEXT NOT NULL,
    telefono VARCHAR(15),
    negocio_nombre TEXT,
    antiguedad_meses INTEGER CHECK (antiguedad_meses >= 0),
    ingresos_estimados NUMERIC(12,2) DEFAULT 0,
    gastos_estimados NUMERIC(12,2) DEFAULT 0,
    ubicacion_lat NUMERIC(10,7),
    ubicacion_lng NUMERIC(10,7)
);

ALTER TABLE clientes_ficha ENABLE ROW LEVEL SECURITY;

CREATE POLICY clientes_ficha_select_policy ON clientes_ficha
    FOR SELECT USING (auth.uid() = usuario_id);

CREATE POLICY clientes_ficha_insert_policy ON clientes_ficha
    FOR INSERT WITH CHECK (auth.uid() = usuario_id);

-- 3. TABLA: cronogramas (compartida ambos apps)
CREATE TABLE IF NOT EXISTS cronogramas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitud_id UUID NOT NULL REFERENCES solicitudes_credito(id) ON DELETE CASCADE,
    numero_cuota INTEGER NOT NULL CHECK (numero_cuota > 0),
    fecha_pago DATE NOT NULL,
    monto_cuota NUMERIC(12,2) NOT NULL,
    capital NUMERIC(12,2) NOT NULL,
    interes NUMERIC(12,2) NOT NULL,
    saldo_pendiente NUMERIC(12,2) NOT NULL
);

ALTER TABLE cronogramas ENABLE ROW LEVEL SECURITY;

CREATE POLICY cronogramas_select_policy ON cronogramas
    FOR SELECT USING (auth.uid() IN (
        SELECT asesor_id FROM solicitudes_credito WHERE id = solicitud_id
        UNION
        SELECT usuario_id FROM clientes_ficha
        WHERE id = (SELECT cliente_id FROM solicitudes_credito WHERE id = solicitud_id)
    ));

-- 4. TABLA: sync_outbox (cola offline genérica)
CREATE TABLE IF NOT EXISTS sync_outbox (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacion TEXT NOT NULL,
    datos_json JSONB NOT NULL DEFAULT '{}',
    pendiente_sync BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE sync_outbox ENABLE ROW LEVEL SECURITY;

CREATE POLICY sync_outbox_select_policy ON sync_outbox
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY sync_outbox_insert_policy ON sync_outbox
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- ==================== NUEVAS TABLAS S11 (App Fuerza Ventas) ====================

-- 5. TABLA: agencias
CREATE TABLE IF NOT EXISTS agencias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    region VARCHAR(50),
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE agencias ENABLE ROW LEVEL SECURITY;

CREATE POLICY agencias_select_policy ON agencias
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY agencias_insert_policy ON agencias
    FOR INSERT WITH CHECK (auth.role() IN ('administrador', 'supervisor'));

CREATE POLICY agencias_update_policy ON agencias
    FOR UPDATE USING (auth.role() IN ('administrador', 'supervisor'));

-- 6. TABLA: asesores_negocio (App Fuerza Ventas - perfil de asesor)
CREATE TABLE IF NOT EXISTS asesores_negocio (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    codigo_empleado VARCHAR(10) UNIQUE NOT NULL,
    clave_hash TEXT NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    agencia_id UUID REFERENCES agencias(id),
    perfil VARCHAR(20) NOT NULL DEFAULT 'operador' CHECK (perfil IN ('operador', 'super_operador', 'supervisor', 'administrador')),
    token_fcm TEXT,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE asesores_negocio ENABLE ROW LEVEL SECURITY;

CREATE POLICY asesores_negocio_select_policy ON asesores_negocio
    FOR SELECT USING (auth.uid() = user_id OR auth.role() IN ('supervisor', 'administrador'));

CREATE POLICY asesores_negocio_update_policy ON asesores_negocio
    FOR UPDATE USING (auth.uid() = user_id OR auth.role() IN ('supervisor', 'administrador'));

-- 7. TABLA: clientes (S11 - perfil completo del cliente para FVentas)
CREATE TABLE IF NOT EXISTS clientes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_documento VARCHAR(15) UNIQUE NOT NULL,
    tipo_documento VARCHAR(5) NOT NULL DEFAULT 'DNI' CHECK (tipo_documento IN ('DNI', 'RUC', 'CE')),
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    estado_civil VARCHAR(15) CHECK (estado_civil IN ('Soltero', 'Casado', 'Conviviente', 'Divorciado', 'Viudo')),
    telefono VARCHAR(15),
    email VARCHAR(100),
    direccion TEXT,
    tipo_negocio VARCHAR(30),
    nombre_negocio VARCHAR(100),
    antiguedad_negocio_meses INTEGER CHECK (antiguedad_negocio_meses >= 0),
    ingresos_estimados NUMERIC(12,2) DEFAULT 0,
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    calificacion_sbs VARCHAR(15) DEFAULT 'Normal',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;

CREATE POLICY clientes_select_policy ON clientes
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY clientes_insert_policy ON clientes
    FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));

CREATE POLICY clientes_update_policy ON clientes
    FOR UPDATE USING (auth.role() IN ('authenticated'));

-- 8. TABLA: creditos (historial crediticio del cliente)
CREATE TABLE IF NOT EXISTS creditos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    agencia_id UUID REFERENCES agencias(id),
    producto VARCHAR(30),
    monto_desembolsado NUMERIC(12,2) NOT NULL,
    plazo_meses INTEGER NOT NULL CHECK (plazo_meses BETWEEN 1 AND 60),
    tea NUMERIC(5,2),
    estado VARCHAR(20) NOT NULL DEFAULT 'vigente' CHECK (estado IN ('vigente', 'pagado', 'vencido', 'castigado')),
    fecha_desembolso DATE,
    fecha_vencimiento DATE,
    saldo_actual NUMERIC(12,2) DEFAULT 0,
    cuotas_total INTEGER DEFAULT 0,
    cuotas_pagadas INTEGER DEFAULT 0,
    dias_mora INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE creditos ENABLE ROW LEVEL SECURITY;

CREATE POLICY creditos_select_policy ON creditos
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY creditos_insert_policy ON creditos
    FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));

-- 9. TABLA: creditos_preaprobados (ofertas de scoring)
CREATE TABLE IF NOT EXISTS creditos_preaprobados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    monto_maximo NUMERIC(12,2) NOT NULL,
    plazo_sugerido_meses INTEGER NOT NULL,
    tea_referencial NUMERIC(5,2),
    score_confianza INTEGER CHECK (score_confianza BETWEEN 0 AND 100),
    vigente BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_calculo DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_vencimiento DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE creditos_preaprobados ENABLE ROW LEVEL SECURITY;

CREATE POLICY creditos_preaprobados_select_policy ON creditos_preaprobados
    FOR SELECT USING (auth.role() = 'authenticated');

-- 10. TABLA: solicitudes_documentos
CREATE TABLE IF NOT EXISTS solicitudes_documentos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitud_id UUID NOT NULL REFERENCES solicitudes_credito(id) ON DELETE CASCADE,
    tipo_documento VARCHAR(40) NOT NULL CHECK (tipo_documento IN (
        'dni_anverso', 'dni_reverso', 'ruc', 'recibo_servicios',
        'foto_negocio', 'foto_visita', 'contrato_arrendamiento'
    )),
    storage_url TEXT,
    tamanio_kb INTEGER,
    nitidez_score NUMERIC(5,2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE solicitudes_documentos ENABLE ROW LEVEL SECURITY;

CREATE POLICY solicitudes_documentos_select_policy ON solicitudes_documentos
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY solicitudes_documentos_insert_policy ON solicitudes_documentos
    FOR INSERT USING (auth.role() IN ('authenticated'));

-- 11. TABLA: consultas_buro
CREATE TABLE IF NOT EXISTS consultas_buro (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    cliente_id UUID NOT NULL REFERENCES clientes(id),
    dni_consultado VARCHAR(15) NOT NULL,
    calificacion_sbs VARCHAR(20),
    entidades_con_deuda INTEGER DEFAULT 0,
    deuda_total_pen NUMERIC(12,2) DEFAULT 0,
    mayor_deuda NUMERIC(12,2) DEFAULT 0,
    dias_mayor_mora INTEGER DEFAULT 0,
    resultado_json JSONB,
    firma_consentimiento_base64 TEXT,
    solicitud_id UUID REFERENCES solicitudes_credito(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE consultas_buro ENABLE ROW LEVEL SECURITY;

CREATE POLICY consultas_buro_select_policy ON consultas_buro
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY consultas_buro_insert_policy ON consultas_buro
    FOR INSERT USING (auth.role() IN ('authenticated'));

-- 12. TABLA: acciones_cobranza
CREATE TABLE IF NOT EXISTS acciones_cobranza (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    cliente_id UUID NOT NULL REFERENCES clientes(id),
    credito_id UUID REFERENCES creditos(id),
    tipo_gestion VARCHAR(20) NOT NULL CHECK (tipo_gestion IN ('visita', 'llamada', 'mensaje')),
    resultado VARCHAR(30) NOT NULL CHECK (resultado IN ('compromiso_pago', 'pago_parcial', 'sin_contacto', 'se_niega')),
    monto_pagado NUMERIC(12,2) DEFAULT 0,
    fecha_compromiso DATE,
    monto_compromiso NUMERIC(12,2) DEFAULT 0,
    observaciones TEXT,
    lat NUMERIC(10,7),
    lng NUMERIC(10,7),
    timestamp_gestion TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE acciones_cobranza ENABLE ROW LEVEL SECURITY;

CREATE POLICY acciones_cobranza_select_policy ON acciones_cobranza
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY acciones_cobranza_insert_policy ON acciones_cobranza
    FOR INSERT USING (auth.role() IN ('authenticated'));

-- 13. TABLA: alertas_cartera
CREATE TABLE IF NOT EXISTS alertas_cartera (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    cliente_id UUID NOT NULL REFERENCES clientes(id),
    tipo_alerta VARCHAR(30) NOT NULL CHECK (tipo_alerta IN (
        'primer_dia_mora', 'mora_30d', 'mora_60d', 'pago_parcial', 'pago_total'
    )),
    mensaje TEXT,
    leida BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE alertas_cartera ENABLE ROW LEVEL SECURITY;

CREATE POLICY alertas_cartera_select_policy ON alertas_cartera
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY alertas_cartera_insert_policy ON alertas_cartera
    FOR INSERT USING (auth.role() IN ('authenticated'));

-- 14. TABLA: solicitudes_notas_internas
CREATE TABLE IF NOT EXISTS solicitudes_notas_internas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitud_id UUID NOT NULL REFERENCES solicitudes_credito(id) ON DELETE CASCADE,
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    contenido TEXT NOT NULL CHECK (length(contenido) <= 500),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE solicitudes_notas_internas ENABLE ROW LEVEL SECURITY;

CREATE POLICY solicitudes_notas_internas_select_policy ON solicitudes_notas_internas
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY solicitudes_notas_internas_insert_policy ON solicitudes_notas_internas
    FOR INSERT USING (auth.role() IN ('authenticated'));

-- 15. TABLA: campanas_activas
CREATE TABLE IF NOT EXISTS campanas_activas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    cliente_id UUID NOT NULL REFERENCES clientes(id),
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('renovacion', 'ampliacion', 'producto_paralelo')),
    monto_ofertado NUMERIC(12,2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE campanas_activas ENABLE ROW LEVEL SECURITY;

CREATE POLICY campanas_activas_select_policy ON campanas_activas
    FOR SELECT USING (auth.role() = 'authenticated');

-- ==================== EXPANSION DE TABLAS EXISTENTES ====================

-- Expandir cartera_diaria con columnas S11
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS agencia_id UUID REFERENCES agencias(id);
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS asesor_negocio_id UUID REFERENCES asesores_negocio(id);
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS score_prioridad INTEGER DEFAULT 0;
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS estado_visita VARCHAR(20) DEFAULT 'pendiente'
    CHECK (estado_visita IN ('pendiente', 'visitado', 'no_encontrado', 'reagendado', 'negocio_cerrado'));
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS resultado_visita VARCHAR(30);
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS observacion_visita TEXT;
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS timestamp_visita TIMESTAMPTZ;
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS lat_visita NUMERIC(10,7);
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS lng_visita NUMERIC(10,7);
ALTER TABLE cartera_diaria ADD COLUMN IF NOT EXISTS orden_manual INTEGER;

-- Expandir solicitudes_credito con columnas S11 (manteniendo compatibilidad)
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS agencia_id UUID REFERENCES agencias(id);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS tipo_negocio VARCHAR(30);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS nombre_negocio VARCHAR(100);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS actividad_economica VARCHAR(10);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS antiguedad_negocio_meses INTEGER;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS ingresos_estimados NUMERIC(12,2) DEFAULT 0;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS gastos_mensuales NUMERIC(12,2) DEFAULT 0;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS patrimonio_estimado NUMERIC(12,2) DEFAULT 0;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS tiene_conyuge BOOLEAN DEFAULT FALSE;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS conyuge_json JSONB;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS tiene_garante BOOLEAN DEFAULT FALSE;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS garante_json JSONB;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS moneda VARCHAR(3) DEFAULT 'PEN' CHECK (moneda IN ('PEN', 'USD'));
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS tipo_cuota VARCHAR(10) DEFAULT 'mensual' CHECK (tipo_cuota IN ('mensual', 'quincenal', 'semanal'));
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS cuota_estimada NUMERIC(10,2);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS tea_referencial NUMERIC(5,2);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS monto_aprobado NUMERIC(12,2);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS condicion_adicional TEXT;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS analista_asignado VARCHAR(100);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS firma_cliente_base64 TEXT;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS lat_captura NUMERIC(10,7);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS lng_captura NUMERIC(10,7);
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS pendiente_sync BOOLEAN DEFAULT FALSE;
ALTER TABLE solicitudes_credito ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

-- Agregar tipo_gestion AMPLIACION, SEGUIMIENTO, DESERTOR si no existen
-- (CHECK constraint original solo tenia RENOVACION, NUEVA_SOLICITUD, RECUPERACION_MORA)
-- Necesitamos recrear la constraint

DO $$
BEGIN
    ALTER TABLE cartera_diaria DROP CONSTRAINT IF EXISTS cartera_diaria_tipo_gestion_check;
EXCEPTION
    WHEN undefined_object THEN NULL;
END;
$$;

ALTER TABLE cartera_diaria ADD CONSTRAINT cartera_diaria_tipo_gestion_check
    CHECK (tipo_gestion IN ('RENOVACION', 'AMPLIACION', 'NUEVA_SOLICITUD', 'SEGUIMIENTO', 'RECUPERACION_MORA', 'DESERTOR'));

-- ==================== VISTAS ====================

-- Vista: cartera_vencida (para modulo M10)
CREATE OR REPLACE VIEW cartera_vencida AS
SELECT
    c.id,
    c.asesor_id,
    c.cliente_id,
    cl.nombre_completo AS cliente_nombre,
    cr.dias_mora,
    cr.saldo_actual AS monto_vencido,
    COALESCE(
        (SELECT MAX(ac.timestamp_gestion) FROM acciones_cobranza ac WHERE ac.cliente_id = c.cliente_id),
        c.timestamp_visita
    ) AS ultimo_contacto
FROM cartera_diaria c
JOIN clientes_ficha cl ON cl.id = c.cliente_id
LEFT JOIN creditos cr ON cr.cliente_id = c.cliente_id
WHERE cr.dias_mora > 0 AND cr.dias_mora IS NOT NULL;

-- ==================== INDICES ====================
CREATE INDEX IF NOT EXISTS idx_cartera_fecha ON cartera_diaria(fecha_asignacion);
CREATE INDEX IF NOT EXISTS idx_solicitudes_estado ON solicitudes_credito(estado);
CREATE INDEX IF NOT EXISTS idx_solicitudes_cliente ON solicitudes_credito(cliente_id);
CREATE INDEX IF NOT EXISTS idx_cronogramas_solicitud ON cronogramas(solicitud_id);
CREATE INDEX IF NOT EXISTS idx_sync_pendiente ON sync_outbox(pendiente_sync);
CREATE INDEX IF NOT EXISTS idx_asesores_agencia ON asesores_negocio(agencia_id);
CREATE INDEX IF NOT EXISTS idx_creditos_cliente ON creditos(cliente_id);
CREATE INDEX IF NOT EXISTS idx_creditos_asesor ON creditos(asesor_id);
CREATE INDEX IF NOT EXISTS idx_preaprobados_cliente ON creditos_preaprobados(cliente_id);
CREATE INDEX IF NOT EXISTS idx_documentos_solicitud ON solicitudes_documentos(solicitud_id);
CREATE INDEX IF NOT EXISTS idx_buro_cliente ON consultas_buro(cliente_id);
CREATE INDEX IF NOT EXISTS idx_cobranza_asesor ON acciones_cobranza(asesor_id);
CREATE INDEX IF NOT EXISTS idx_alertas_asesor ON alertas_cartera(asesor_id);
CREATE INDEX IF NOT EXISTS idx_notas_solicitud ON solicitudes_notas_internas(solicitud_id);
CREATE INDEX IF NOT EXISTS idx_campanas_asesor ON campanas_activas(asesor_id);
CREATE INDEX IF NOT EXISTS idx_cartera_asesor_fecha ON cartera_diaria(asesor_id, fecha_asignacion);
CREATE INDEX IF NOT EXISTS idx_clientes_documento ON clientes(numero_documento);
