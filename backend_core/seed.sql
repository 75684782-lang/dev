-- ============================================================
-- CRAC Incasur - bd_core_mobile
-- SEED DATA: Casos simulados
-- Caso 1: Anaximandro Quispe (Renovación)
-- Caso 2: Eulalia Mamani (Nueva Solicitud)
-- ============================================================

-- 1. USUARIOS
INSERT INTO usuarios (dni, clave_hash, rol) VALUES
('12345678', '$2b$12$LJ3m4ys3Lk0TSwHnbfOMiOXPm1Qlq5y0q5y0q5y0q5y0q5y0q5y0q', 'cliente'),
('87654321', '$2b$12$LJ3m4ys3Lk0TSwHnbfOMiOXPm1Qlq5y0q5y0q5y0q5y0q5y0q5y0q', 'cliente'),
('11111111', '$2b$12$LJ3m4ys3Lk0TSwHnbfOMiOXPm1Qlq5y0q5y0q5y0q5y0q5y0q5y0q', 'operador'),
('22222222', '$2b$12$LJ3m4ys3Lk0TSwHnbfOMiOXPm1Qlq5y0q5y0q5y0q5y0q5y0q5y0q', 'supervisor'),
('99999999', '$2b$12$LJ3m4ys3Lk0TSwHnbfOMiOXPm1Qlq5y0q5y0q5y0q5y0q5y0q5y0q', 'administrador')
ON CONFLICT (dni) DO NOTHING;

-- 2. CLIENTES_FICHA
INSERT INTO clientes_ficha (usuario_id, nombre_completo, telefono, negocio_nombre, antiguedad_meses, ingresos_estimados, gastos_estimados, ubicacion_lat, ubicacion_lng)
SELECT
    u.id, 'Anaximandro Quispe Huamán', '987654321', 'Bodega Don Anaximandro', 48, 3500.00, 1800.00, -13.5320000, -71.9675000
FROM usuarios u WHERE u.dni = '12345678';

INSERT INTO clientes_ficha (usuario_id, nombre_completo, telefono, negocio_nombre, antiguedad_meses, ingresos_estimados, gastos_estimados, ubicacion_lat, ubicacion_lng)
SELECT
    u.id, 'Eulalia Mamani Condori', '976543210', 'Pollería La Sabrosita', 18, 2800.00, 1500.00, -13.5250000, -71.9720000
FROM usuarios u WHERE u.dni = '87654321';

-- 3. CARTERA_DIARIA
INSERT INTO cartera_diaria (asesor_id, cliente_id, tipo_gestion, prioridad, visitado, fecha_asignacion)
SELECT
    (SELECT id FROM usuarios WHERE dni = '11111111'),
    c.id, 'RENOVACION', 'ALTA', FALSE, CURRENT_DATE
FROM clientes_ficha c WHERE c.nombre_completo = 'Anaximandro Quispe Huamán';

INSERT INTO cartera_diaria (asesor_id, cliente_id, tipo_gestion, prioridad, visitado, fecha_asignacion)
SELECT
    (SELECT id FROM usuarios WHERE dni = '11111111'),
    c.id, 'NUEVA_SOLICITUD', 'MEDIA', FALSE, CURRENT_DATE
FROM clientes_ficha c WHERE c.nombre_completo = 'Eulalia Mamani Condori';

-- 4. SOLICITUDES_CREDITO
INSERT INTO solicitudes_credito (numero_expediente, cliente_id, asesor_id, monto_solicitado, plazo_meses, tea, con_desgravamen, garantia, destino_credito, estado, creado_en)
SELECT
    'EXP-2026-0001',
    c.id,
    (SELECT id FROM usuarios WHERE dni = '11111111'),
    5000.00, 12, 43.92, TRUE, 'Garantía personal', 'Compra de mercadería', 'enviado',
    now() - interval '2 days'
FROM clientes_ficha c WHERE c.nombre_completo = 'Anaximandro Quispe Huamán';

INSERT INTO solicitudes_credito (numero_expediente, cliente_id, asesor_id, monto_solicitado, plazo_meses, tea, con_desgravamen, garantia, destino_credito, estado, creado_en)
SELECT
    'EXP-2026-0002',
    c.id,
    (SELECT id FROM usuarios WHERE dni = '11111111'),
    3000.00, 8, 40.92, TRUE, 'Prenda comercial', 'Equipamiento de cocina', 'en_evaluacion',
    now() - interval '1 day'
FROM clientes_ficha c WHERE c.nombre_completo = 'Eulalia Mamani Condori';

-- 5. CRONOGRAMAS (solo para EXP-2026-0001 aprobado con cuota fija)
DO $$
DECLARE
    v_solicitud_id UUID;
    v_monto NUMERIC(12,2);
    v_plazo INTEGER;
    v_tea NUMERIC(5,2);
    v_tem NUMERIC(10,8);
    v_cuota_fija NUMERIC(12,2);
    v_saldo NUMERIC(12,2);
    v_interes NUMERIC(12,2);
    v_capital NUMERIC(12,2);
    v_i INTEGER;
    v_fecha DATE;
BEGIN
    SELECT id, monto_solicitado, plazo_meses, tea
    INTO v_solicitud_id, v_monto, v_plazo, v_tea
    FROM solicitudes_credito WHERE numero_expediente = 'EXP-2026-0001';

    v_tem := POWER(1 + v_tea/100, 1.0/12) - 1;
    v_cuota_fija := ROUND(v_monto * (v_tem * POWER(1 + v_tem, v_plazo)) / (POWER(1 + v_tem, v_plazo) - 1), 2);
    v_saldo := v_monto;
    v_fecha := CURRENT_DATE + interval '1 month';

    FOR v_i IN 1..v_plazo LOOP
        v_interes := ROUND(v_saldo * v_tem, 2);
        v_capital := ROUND(v_cuota_fija - v_interes, 2);
        IF v_i = v_plazo THEN
            v_capital := v_saldo;
            v_cuota_fija := v_capital + v_interes;
        END IF;
        v_saldo := ROUND(v_saldo - v_capital, 2);

        INSERT INTO cronogramas (solicitud_id, numero_cuota, fecha_pago, monto_cuota, capital, interes, saldo_pendiente)
        VALUES (v_solicitud_id, v_i, v_fecha, v_cuota_fija, v_capital, v_interes, v_saldo);

        v_fecha := v_fecha + interval '1 month';
    END LOOP;
END $$;
