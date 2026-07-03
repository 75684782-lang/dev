-- ============================================================================
-- CRAC Incasur - DDL COMPLETO para Supabase (Schema A + tablas faltantes)
-- Combina backend_core/schema.sql con las tablas base faltantes
-- ============================================================================

-- ==================== TABLA: usuarios (App Cliente - homebanking) ====================
CREATE TABLE IF NOT EXISTS usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dni VARCHAR(8) UNIQUE NOT NULL CHECK (dni ~ '^\d{8}$'),
    clave_hash TEXT NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('operador', 'cliente', 'supervisor', 'administrador')),
    creado_en TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS usuarios_select_policy ON usuarios;
CREATE POLICY usuarios_select_policy ON usuarios FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS usuarios_insert_policy ON usuarios;
CREATE POLICY usuarios_insert_policy ON usuarios FOR INSERT WITH CHECK (auth.uid() = id);

-- ==================== TABLA: clientes_ficha (App Cliente - homebanking) ====================
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
DROP POLICY IF EXISTS clientes_ficha_select_policy ON clientes_ficha;
CREATE POLICY clientes_ficha_select_policy ON clientes_ficha FOR SELECT USING (auth.uid() = usuario_id);
DROP POLICY IF EXISTS clientes_ficha_insert_policy ON clientes_ficha;
CREATE POLICY clientes_ficha_insert_policy ON clientes_ficha FOR INSERT WITH CHECK (auth.uid() = usuario_id);

-- ==================== TABLA: agencias ====================
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
DROP POLICY IF EXISTS agencias_select_policy ON agencias;
CREATE POLICY agencias_select_policy ON agencias FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS agencias_insert_policy ON agencias;
CREATE POLICY agencias_insert_policy ON agencias FOR INSERT WITH CHECK (auth.role() IN ('administrador', 'supervisor'));
DROP POLICY IF EXISTS agencias_update_policy ON agencias;
CREATE POLICY agencias_update_policy ON agencias FOR UPDATE USING (auth.role() IN ('administrador', 'supervisor'));

-- ==================== TABLA: asesores_negocio (App Fuerza Ventas) ====================
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
DROP POLICY IF EXISTS asesores_negocio_select_policy ON asesores_negocio;
CREATE POLICY asesores_negocio_select_policy ON asesores_negocio FOR SELECT USING (auth.uid() = user_id OR auth.role() IN ('supervisor', 'administrador'));
DROP POLICY IF EXISTS asesores_negocio_update_policy ON asesores_negocio;
CREATE POLICY asesores_negocio_update_policy ON asesores_negocio FOR UPDATE USING (auth.uid() = user_id OR auth.role() IN ('supervisor', 'administrador'));

-- ==================== TABLA: clientes (S11 - perfil completo) ====================
CREATE TABLE IF NOT EXISTS clientes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clientes_ficha_id UUID REFERENCES clientes_ficha(id) ON DELETE SET NULL,
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
DROP POLICY IF EXISTS clientes_select_policy ON clientes;
CREATE POLICY clientes_select_policy ON clientes FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS clientes_insert_policy ON clientes;
CREATE POLICY clientes_insert_policy ON clientes FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));
DROP POLICY IF EXISTS clientes_update_policy ON clientes;
CREATE POLICY clientes_update_policy ON clientes FOR UPDATE USING (auth.role() IN ('authenticated'));

-- ==================== TABLA: creditos (historial crediticio) ====================
CREATE TABLE IF NOT EXISTS creditos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL REFERENCES clientes_ficha(id) ON DELETE CASCADE,
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
DROP POLICY IF EXISTS creditos_select_policy ON creditos;
CREATE POLICY creditos_select_policy ON creditos FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS creditos_insert_policy ON creditos;
CREATE POLICY creditos_insert_policy ON creditos FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));

-- ==================== TABLA: creditos_preaprobados ====================
CREATE TABLE IF NOT EXISTS creditos_preaprobados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL REFERENCES clientes_ficha(id) ON DELETE CASCADE,
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
DROP POLICY IF EXISTS creditos_preaprobados_select_policy ON creditos_preaprobados;
CREATE POLICY creditos_preaprobados_select_policy ON creditos_preaprobados FOR SELECT USING (auth.role() = 'authenticated');

-- ==================== TABLA: cartera_diaria ====================
CREATE TABLE IF NOT EXISTS cartera_diaria (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asesor_id          UUID NOT NULL,  -- auth.users.id
    cliente_id         UUID NOT NULL REFERENCES clientes_ficha(id),
    agencia_id         UUID REFERENCES agencias(id),
    fecha_asignacion   DATE NOT NULL DEFAULT CURRENT_DATE,
    tipo_gestion       VARCHAR(30) NOT NULL,
    prioridad          VARCHAR(10) DEFAULT 'normal',
    visitado           BOOLEAN NOT NULL DEFAULT FALSE,
    monto_credito      NUMERIC(12,2),
    score_prioridad    INTEGER DEFAULT 0,
    estado_visita      VARCHAR(20) DEFAULT 'pendiente',
    resultado_visita   VARCHAR(30),
    observacion_visita TEXT,
    timestamp_visita   TIMESTAMPTZ,
    lat_visita         NUMERIC(10,7),
    lng_visita         NUMERIC(10,7),
    orden_manual       INTEGER,
    asesor_negocio_id  UUID REFERENCES asesores_negocio(id),
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE cartera_diaria ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS cartera_diaria_select_policy ON cartera_diaria;
CREATE POLICY cartera_diaria_select_policy ON cartera_diaria FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS cartera_diaria_insert_policy ON cartera_diaria;
CREATE POLICY cartera_diaria_insert_policy ON cartera_diaria FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));
DROP POLICY IF EXISTS cartera_diaria_update_policy ON cartera_diaria;
CREATE POLICY cartera_diaria_update_policy ON cartera_diaria FOR UPDATE USING (auth.role() IN ('authenticated'));

-- ==================== TABLA: solicitudes_credito ====================
CREATE TABLE IF NOT EXISTS solicitudes_credito (
    id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_expediente        VARCHAR(20) UNIQUE,
    asesor_id                UUID NOT NULL,  -- auth.users.id
    cliente_id               UUID NOT NULL REFERENCES clientes_ficha(id),
    agencia_id               UUID REFERENCES agencias(id),
    monto_solicitado         NUMERIC(12,2) NOT NULL,
    plazo_meses              INTEGER,
    tea                      NUMERIC(5,2),
    con_desgravamen          BOOLEAN DEFAULT TRUE,
    garantia                 VARCHAR(20),
    destino_credito          TEXT,
    estado                   VARCHAR(30) NOT NULL DEFAULT 'borrador',
    motivo_rechazo           TEXT,
    monto_aprobado           NUMERIC(12,2),
    tipo_negocio             VARCHAR(30),
    nombre_negocio           VARCHAR(100),
    actividad_economica      VARCHAR(10),
    antiguedad_negocio_meses INTEGER,
    ingresos_estimados       NUMERIC(12,2) DEFAULT 0,
    gastos_mensuales         NUMERIC(12,2) DEFAULT 0,
    patrimonio_estimado      NUMERIC(12,2) DEFAULT 0,
    tiene_conyuge            BOOLEAN DEFAULT FALSE,
    conyuge_json             JSONB,
    tiene_garante            BOOLEAN DEFAULT FALSE,
    garante_json             JSONB,
    moneda                   VARCHAR(3) DEFAULT 'PEN',
    tipo_cuota               VARCHAR(10) DEFAULT 'mensual',
    cuota_estimada           NUMERIC(10,2),
    tea_referencial          NUMERIC(5,2),
    condicion_adicional      TEXT,
    analista_asignado        VARCHAR(100),
    firma_cliente_base64     TEXT,
    lat_captura              NUMERIC(10,7),
    lng_captura              NUMERIC(10,7),
    pendiente_sync           BOOLEAN NOT NULL DEFAULT FALSE,
    creado_en                TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at               TIMESTAMPTZ
);

ALTER TABLE solicitudes_credito ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS solicitudes_credito_select_policy ON solicitudes_credito;
CREATE POLICY solicitudes_credito_select_policy ON solicitudes_credito FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS solicitudes_credito_insert_policy ON solicitudes_credito;
CREATE POLICY solicitudes_credito_insert_policy ON solicitudes_credito FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));
DROP POLICY IF EXISTS solicitudes_credito_update_policy ON solicitudes_credito;
CREATE POLICY solicitudes_credito_update_policy ON solicitudes_credito FOR UPDATE USING (auth.role() IN ('authenticated'));

-- ==================== TABLA: solicitudes_documentos ====================
CREATE TABLE IF NOT EXISTS solicitudes_documentos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitud_id UUID NOT NULL REFERENCES solicitudes_credito(id) ON DELETE CASCADE,
    tipo_documento VARCHAR(40) NOT NULL CHECK (tipo_documento IN ('dni_anverso','dni_reverso','ruc','licencia','boleta','local','recibo_servicios','foto_negocio','foto_visita','contrato_arrendamiento')),
    storage_url TEXT,
    tamanio_kb INTEGER,
    nitidez_score NUMERIC(5,2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE solicitudes_documentos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS solicitudes_documentos_select_policy ON solicitudes_documentos;
CREATE POLICY solicitudes_documentos_select_policy ON solicitudes_documentos FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS solicitudes_documentos_insert_policy ON solicitudes_documentos;
CREATE POLICY solicitudes_documentos_insert_policy ON solicitudes_documentos FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));

-- ==================== TABLA: consultas_buro ====================
CREATE TABLE IF NOT EXISTS consultas_buro (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    cliente_id UUID NOT NULL REFERENCES clientes_ficha(id),
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
DROP POLICY IF EXISTS consultas_buro_select_policy ON consultas_buro;
CREATE POLICY consultas_buro_select_policy ON consultas_buro FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS consultas_buro_insert_policy ON consultas_buro;
CREATE POLICY consultas_buro_insert_policy ON consultas_buro FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));

-- ==================== TABLA: acciones_cobranza ====================
CREATE TABLE IF NOT EXISTS acciones_cobranza (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    cliente_id UUID NOT NULL REFERENCES clientes_ficha(id),
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
DROP POLICY IF EXISTS acciones_cobranza_select_policy ON acciones_cobranza;
CREATE POLICY acciones_cobranza_select_policy ON acciones_cobranza FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS acciones_cobranza_insert_policy ON acciones_cobranza;
CREATE POLICY acciones_cobranza_insert_policy ON acciones_cobranza FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));

-- ==================== TABLA: alertas_cartera ====================
CREATE TABLE IF NOT EXISTS alertas_cartera (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    cliente_id UUID NOT NULL REFERENCES clientes_ficha(id),
    tipo_alerta VARCHAR(30) NOT NULL CHECK (tipo_alerta IN ('primer_dia_mora','mora_30d','mora_60d','pago_parcial','pago_total')),
    mensaje TEXT,
    leida BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE alertas_cartera ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS alertas_cartera_select_policy ON alertas_cartera;
CREATE POLICY alertas_cartera_select_policy ON alertas_cartera FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS alertas_cartera_insert_policy ON alertas_cartera;
CREATE POLICY alertas_cartera_insert_policy ON alertas_cartera FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));

-- ==================== TABLA: solicitudes_notas_internas ====================
CREATE TABLE IF NOT EXISTS solicitudes_notas_internas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitud_id UUID NOT NULL REFERENCES solicitudes_credito(id) ON DELETE CASCADE,
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    contenido TEXT NOT NULL CHECK (length(contenido) <= 500),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE solicitudes_notas_internas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS solicitudes_notas_internas_select_policy ON solicitudes_notas_internas;
CREATE POLICY solicitudes_notas_internas_select_policy ON solicitudes_notas_internas FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS solicitudes_notas_internas_insert_policy ON solicitudes_notas_internas;
CREATE POLICY solicitudes_notas_internas_insert_policy ON solicitudes_notas_internas FOR INSERT WITH CHECK (auth.role() IN ('authenticated'));

-- ==================== TABLA: campanas_activas ====================
CREATE TABLE IF NOT EXISTS campanas_activas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asesor_id UUID NOT NULL REFERENCES asesores_negocio(id),
    cliente_id UUID NOT NULL REFERENCES clientes_ficha(id),
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('renovacion', 'ampliacion', 'producto_paralelo')),
    monto_ofertado NUMERIC(12,2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE campanas_activas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS campanas_activas_select_policy ON campanas_activas;
CREATE POLICY campanas_activas_select_policy ON campanas_activas FOR SELECT USING (auth.role() = 'authenticated');

-- ==================== TABLA: cronogramas ====================
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
DROP POLICY IF EXISTS cronogramas_select_policy ON cronogramas;
CREATE POLICY cronogramas_select_policy ON cronogramas FOR SELECT USING (auth.role() = 'authenticated');

-- ==================== TABLA: sync_outbox ====================
CREATE TABLE IF NOT EXISTS sync_outbox (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacion TEXT NOT NULL,
    datos_json JSONB NOT NULL DEFAULT '{}',
    pendiente_sync BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE sync_outbox ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS sync_outbox_select_policy ON sync_outbox;
CREATE POLICY sync_outbox_select_policy ON sync_outbox FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS sync_outbox_insert_policy ON sync_outbox;
CREATE POLICY sync_outbox_insert_policy ON sync_outbox FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- ==================== CHECK CONSTRAINTS for cartera_diaria ====================
ALTER TABLE cartera_diaria DROP CONSTRAINT IF EXISTS cartera_diaria_tipo_gestion_check;
ALTER TABLE cartera_diaria ADD CONSTRAINT cartera_diaria_tipo_gestion_check
    CHECK (tipo_gestion IN ('RENOVACION', 'AMPLIACION', 'NUEVA_SOLICITUD', 'SEGUIMIENTO', 'RECUPERACION_MORA', 'DESERTOR'));

ALTER TABLE cartera_diaria DROP CONSTRAINT IF EXISTS cartera_diaria_prioridad_check;
ALTER TABLE cartera_diaria ADD CONSTRAINT cartera_diaria_prioridad_check
    CHECK (prioridad IN ('alta', 'media', 'normal'));

ALTER TABLE cartera_diaria DROP CONSTRAINT IF EXISTS cartera_diaria_estado_visita_check;
ALTER TABLE cartera_diaria ADD CONSTRAINT cartera_diaria_estado_visita_check
    CHECK (estado_visita IN ('pendiente', 'visitado', 'no_encontrado', 'reagendado', 'negocio_cerrado'));

-- ==================== CHECK CONSTRAINTS for solicitudes_credito ====================
ALTER TABLE solicitudes_credito DROP CONSTRAINT IF EXISTS solicitudes_credito_estado_check;
ALTER TABLE solicitudes_credito ADD CONSTRAINT solicitudes_credito_estado_check
    CHECK (estado IN ('borrador', 'enviado', 'recibido_comite', 'en_evaluacion', 'aprobado', 'condicionado', 'rechazado', 'desembolsado'));

-- ==================== INDICES ====================
CREATE INDEX IF NOT EXISTS idx_cartera_fecha ON cartera_diaria(fecha_asignacion);
CREATE INDEX IF NOT EXISTS idx_cartera_asesor_fecha ON cartera_diaria(asesor_id, fecha_asignacion);
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
CREATE INDEX IF NOT EXISTS idx_clientes_documento ON clientes(numero_documento);

-- ==================== VISTA: cartera_vencida ====================
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
