BEGIN;

-- ================= CASO 1 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('dd222876-b963-49d9-ae9e-ec3d714bf121', '40118120', 'Anaximandro', 'Quispe', '964110201', 'Bodega', 'Bodega Don Anaxi', 48, 2200.00, -12.0581, -75.2027, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'dd222876-b963-49d9-ae9e-ec3d714bf121', CURRENT_DATE, 'NUEVA_SOLICITUD', 'normal', 'visitado', -12.0581, -75.2027);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('573df6de-3909-4fdb-9d6a-e046bfdee976', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'dd222876-b963-49d9-ae9e-ec3d714bf121', 1000.00, 12, 43.92, 'sin garantia', 'Capital de trabajo: compra de mercaderia', 'desembolsado', 1000.00, 'Bodega', 'Bodega Don Anaxi', 48, 2200.00, 900.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('6ef6b2de-baba-486e-80bc-6b3f8079b369', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'dd222876-b963-49d9-ae9e-ec3d714bf121', '573df6de-3909-4fdb-9d6a-e046bfdee976', '40118120', 'NORMAL', 1, 4500.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('f71ff54f-fb1f-4f00-bbe9-3b6f2950d7ef', 'CTA-40118120-1', 'dd222876-b963-49d9-ae9e-ec3d714bf121', 1000.00, 1000.00, 1000.00, 'vigente', CURRENT_DATE, 43.92, 12);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 1, '2026-07-18', 100.95, 70.14, 30.81, 929.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 2, '2026-08-18', 100.95, 72.3, 28.64, 857.56, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 3, '2026-09-18', 100.95, 74.53, 26.42, 783.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 4, '2026-10-18', 100.95, 76.82, 24.12, 706.21, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 5, '2026-11-18', 100.95, 79.19, 21.76, 627.02, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 6, '2026-12-18', 100.95, 81.63, 19.32, 545.39, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 7, '2027-01-18', 100.95, 84.14, 16.8, 461.24, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 8, '2027-02-18', 100.95, 86.74, 14.21, 374.5, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 9, '2027-03-18', 100.95, 89.41, 11.54, 285.09, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 10, '2027-04-18', 100.95, 92.16, 8.78, 192.93, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 11, '2027-05-18', 100.95, 95.0, 5.94, 97.93, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40118120-1', 12, '2027-06-18', 100.95, 97.93, 3.02, 0, 'pendiente');

-- ================= CASO 2 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('5a33ac48-d2f3-41af-b867-ffc8d3c3fce3', '41223341', 'Eulalia', 'Mamani', '964110202', 'Restaurante', 'Picanteria La Eulalia', 36, 3000.00, -12.0921, -75.2105, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '5a33ac48-d2f3-41af-b867-ffc8d3c3fce3', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0921, -75.2105);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('a007972d-0310-4152-a63e-8253e5bf6b6d', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '5a33ac48-d2f3-41af-b867-ffc8d3c3fce3', 3000.00, 12, 40.92, 'sin garantia', 'Compra de cocina industrial', 'desembolsado', 3000.00, 'Restaurante', 'Picanteria La Eulalia', 36, 3000.00, 1400.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('cf7b10a4-b72d-4bcc-9d70-3e73521b37f9', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '5a33ac48-d2f3-41af-b867-ffc8d3c3fce3', 'a007972d-0310-4152-a63e-8253e5bf6b6d', '41223341', 'NORMAL', 2, 12000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('f9db5f84-81bd-4e8d-a8da-9895f1fa21ed', 'CTA-41223341-2', '5a33ac48-d2f3-41af-b867-ffc8d3c3fce3', 3000.00, 3000.00, 3000.00, 'vigente', CURRENT_DATE, 40.92, 12);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 1, '2026-07-18', 299.59, 212.59, 86.99, 2787.41, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 2, '2026-08-18', 299.59, 218.76, 80.83, 2568.65, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 3, '2026-09-18', 299.59, 225.1, 74.48, 2343.55, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 4, '2026-10-18', 299.59, 231.63, 67.96, 2111.92, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 5, '2026-11-18', 299.59, 238.35, 61.24, 1873.58, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 6, '2026-12-18', 299.59, 245.26, 54.33, 1628.32, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 7, '2027-01-18', 299.59, 252.37, 47.22, 1375.95, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 8, '2027-02-18', 299.59, 259.69, 39.9, 1116.26, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 9, '2027-03-18', 299.59, 267.22, 32.37, 849.05, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 10, '2027-04-18', 299.59, 274.97, 24.62, 574.08, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 11, '2027-05-18', 299.59, 282.94, 16.65, 291.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41223341-2', 12, '2027-06-18', 299.59, 291.14, 8.44, 0, 'pendiente');

-- ================= CASO 3 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('9ae822b3-e432-48a7-8fa6-c84258946993', '42330336', 'Teofilo', 'Huaman', '964110203', 'Carpinteria', 'Maderas Huaman', 60, 4200.00, -12.0496, -75.2486, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '9ae822b3-e432-48a7-8fa6-c84258946993', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0496, -75.2486);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('8d9a1bd2-974a-4f3b-adcd-5e0230e1c3dd', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '9ae822b3-e432-48a7-8fa6-c84258946993', 5000.00, 18, 43.92, 'sin garantia', 'Maquinaria: sierra y cepillo', 'desembolsado', 5000.00, 'Carpinteria', 'Maderas Huaman', 60, 4200.00, 1800.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('0ace7c0a-a86b-44b4-a41f-71116852e086', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '9ae822b3-e432-48a7-8fa6-c84258946993', '8d9a1bd2-974a-4f3b-adcd-5e0230e1c3dd', '42330336', 'NORMAL', 1, 6000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('77cdcea2-16b6-43e5-a897-c0bc19befb35', 'CTA-42330336-3', '9ae822b3-e432-48a7-8fa6-c84258946993', 5000.00, 5000.00, 5000.00, 'vigente', CURRENT_DATE, 43.92, 18);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 1, '2026-07-18', 366.02, 212.0, 154.03, 4788.0, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 2, '2026-08-18', 366.02, 218.53, 147.5, 4569.48, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 3, '2026-09-18', 366.02, 225.26, 140.77, 4344.22, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 4, '2026-10-18', 366.02, 232.2, 133.83, 4112.02, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 5, '2026-11-18', 366.02, 239.35, 126.67, 3872.67, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 6, '2026-12-18', 366.02, 246.72, 119.3, 3625.95, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 7, '2027-01-18', 366.02, 254.32, 111.7, 3371.62, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 8, '2027-02-18', 366.02, 262.16, 103.86, 3109.46, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 9, '2027-03-18', 366.02, 270.24, 95.79, 2839.23, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 10, '2027-04-18', 366.02, 278.56, 87.46, 2560.67, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 11, '2027-05-18', 366.02, 287.14, 78.88, 2273.53, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 12, '2027-06-18', 366.02, 295.99, 70.04, 1977.54, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 13, '2027-07-18', 366.02, 305.1, 60.92, 1672.43, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 14, '2027-08-18', 366.02, 314.5, 51.52, 1357.93, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 15, '2027-09-18', 366.02, 324.19, 41.83, 1033.74, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 16, '2027-10-18', 366.02, 334.18, 31.84, 699.56, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 17, '2027-11-18', 366.02, 344.47, 21.55, 355.09, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42330336-3', 18, '2027-12-18', 366.02, 355.09, 10.94, 0, 'pendiente');

-- ================= CASO 4 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('9dd316fd-d04e-4815-bbfd-c488e00f581b', '43440349', 'Casandra', 'Flores', '964110204', 'Abarrotes', 'Distribuidora Casandra', 84, 7000.00, -12.0651, -75.2049, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '9dd316fd-d04e-4815-bbfd-c488e00f581b', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -12.0651, -75.2049);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('9a06fc57-2578-4989-9004-7f75d2bbac3b', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '9dd316fd-d04e-4815-bbfd-c488e00f581b', 8000.00, 6, 43.92, 'sin garantia', 'Reposicion de stock por campana', 'desembolsado', 8000.00, 'Abarrotes', 'Distribuidora Casandra', 84, 7000.00, 2600.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('2de256fd-9faf-4009-89d0-66c914a7f3d2', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '9dd316fd-d04e-4815-bbfd-c488e00f581b', '9a06fc57-2578-4989-9004-7f75d2bbac3b', '43440349', 'NORMAL', 2, 14000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('ae0dfc77-7202-4490-8281-59e3283febed', 'CTA-43440349-4', '9dd316fd-d04e-4815-bbfd-c488e00f581b', 8000.00, 8000.00, 8000.00, 'vigente', CURRENT_DATE, 43.92, 6);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43440349-4', 1, '2026-07-18', 1480.73, 1234.28, 246.44, 6765.72, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43440349-4', 2, '2026-08-18', 1480.73, 1272.3, 208.42, 5493.42, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43440349-4', 3, '2026-09-18', 1480.73, 1311.5, 169.23, 4181.92, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43440349-4', 4, '2026-10-18', 1480.73, 1351.9, 128.83, 2830.02, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43440349-4', 5, '2026-11-18', 1480.73, 1393.55, 87.18, 1436.47, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43440349-4', 6, '2026-12-18', 1480.73, 1436.47, 44.25, 0, 'pendiente');

-- ================= CASO 5 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('6d05157d-8bae-4870-afde-ab26b0eb42f4', '40556071', 'Demostenes', 'Rojas', '964110205', 'Ferreteria', 'Ferreteria El Constructor', 30, 5200.0, -12.0188, -75.2271, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '6d05157d-8bae-4870-afde-ab26b0eb42f4', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -12.0188, -75.2271);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('8f8c219c-4772-4bfa-a6dd-1a379ce2177b', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '6d05157d-8bae-4870-afde-ab26b0eb42f4', 10000.00, 12, 43.92, 'hipotecaria', 'Ampliacion de local', 'desembolsado', 10000.00, 'Ferreteria', 'Ferreteria El Constructor', 30, 5200.0, 2100.0);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('34731174-fdc6-4c30-8718-ec830bcaf612', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '6d05157d-8bae-4870-afde-ab26b0eb42f4', '8f8c219c-4772-4bfa-a6dd-1a379ce2177b', '40556071', 'NORMAL', 2, 12000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('7be1dfe4-357e-44c7-a2f1-a40cabd2e4f9', 'CTA-40556071-5', '6d05157d-8bae-4870-afde-ab26b0eb42f4', 10000.00, 10000.00, 10000.00, 'vigente', CURRENT_DATE, 43.92, 12);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 1, '2026-07-18', 1009.46, 701.4, 308.06, 9298.6, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 2, '2026-08-18', 1009.46, 723.01, 286.45, 8575.59, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 3, '2026-09-18', 1009.46, 745.28, 264.18, 7830.31, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 4, '2026-10-18', 1009.46, 768.24, 241.22, 7062.07, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 5, '2026-11-18', 1009.46, 791.91, 217.55, 6270.16, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 6, '2026-12-18', 1009.46, 816.3, 193.16, 5453.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 7, '2027-01-18', 1009.46, 841.45, 168.01, 4612.41, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 8, '2027-02-18', 1009.46, 867.37, 142.09, 3745.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 9, '2027-03-18', 1009.46, 894.09, 115.37, 2850.95, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 10, '2027-04-18', 1009.46, 921.63, 87.83, 1929.31, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 11, '2027-05-18', 1009.46, 950.02, 59.43, 979.29, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556071-5', 12, '2027-06-18', 1009.46, 979.29, 30.17, 0, 'pendiente');

-- ================= CASO 6 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('450edb2e-a2ef-4477-b172-e07f1f7f3de9', '41669066', 'Hipatia', 'Condori', '964110206', 'Textil', 'Confecciones Hipatia', 54, 6800.00, -12.0612, -75.2118, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '450edb2e-a2ef-4477-b172-e07f1f7f3de9', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0612, -75.2118);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('b8266f42-6351-4a37-b895-74f58f429722', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '450edb2e-a2ef-4477-b172-e07f1f7f3de9', 12000.00, 24, 40.92, 'hipotecaria', 'Compra de maquinas remalladoras', 'desembolsado', 12000.00, 'Textil', 'Confecciones Hipatia', 54, 6800.00, 2900.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('40c9ec65-fbce-4e78-bac9-81969b23a6df', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '450edb2e-a2ef-4477-b172-e07f1f7f3de9', 'b8266f42-6351-4a37-b895-74f58f429722', '41669066', 'NORMAL', 1, 6000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('c2650e5f-59d1-4d7f-9f6e-bc429a325e7b', 'CTA-41669066-6', '450edb2e-a2ef-4477-b172-e07f1f7f3de9', 12000.00, 12000.00, 12000.00, 'vigente', CURRENT_DATE, 40.92, 24);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 1, '2026-07-18', 700.94, 352.97, 347.97, 11647.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 2, '2026-08-18', 700.94, 363.2, 337.74, 11283.83, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 3, '2026-09-18', 700.94, 373.74, 327.2, 10910.09, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 4, '2026-10-18', 700.94, 384.57, 316.37, 10525.52, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 5, '2026-11-18', 700.94, 395.72, 305.22, 10129.79, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 6, '2026-12-18', 700.94, 407.2, 293.74, 9722.59, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 7, '2027-01-18', 700.94, 419.01, 281.93, 9303.59, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 8, '2027-02-18', 700.94, 431.16, 269.78, 8872.43, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 9, '2027-03-18', 700.94, 443.66, 257.28, 8428.77, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 10, '2027-04-18', 700.94, 456.53, 244.41, 7972.24, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 11, '2027-05-18', 700.94, 469.76, 231.18, 7502.48, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 12, '2027-06-18', 700.94, 483.39, 217.55, 7019.09, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 13, '2027-07-18', 700.94, 497.4, 203.54, 6521.69, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 14, '2027-08-18', 700.94, 511.83, 189.11, 6009.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 15, '2027-09-18', 700.94, 526.67, 174.27, 5483.2, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 16, '2027-10-18', 700.94, 541.94, 159.0, 4941.26, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 17, '2027-11-18', 700.94, 557.66, 143.28, 4383.6, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 18, '2027-12-18', 700.94, 573.83, 127.11, 3809.77, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 19, '2028-01-18', 700.94, 590.47, 110.47, 3219.31, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 20, '2028-02-18', 700.94, 607.59, 93.35, 2611.72, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 21, '2028-03-18', 700.94, 625.21, 75.73, 1986.51, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 22, '2028-04-18', 700.94, 643.34, 57.6, 1343.18, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 23, '2028-05-18', 700.94, 661.99, 38.95, 681.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669066-6', 24, '2028-06-18', 700.94, 681.19, 19.75, 0, 'pendiente');

-- ================= CASO 7 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('a3df722e-9568-4292-ba60-8be66c213e80', '43773379', 'Anibal', 'Vargas', '964110207', 'Transporte', 'Transportes Anibal', 42, 9500.00, -11.9182, -75.3142, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'a3df722e-9568-4292-ba60-8be66c213e80', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -11.9182, -75.3142);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('4c72b0a0-8bc1-4277-b9c9-69d12ca6b0d5', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'a3df722e-9568-4292-ba60-8be66c213e80', 15000.00, 18, 43.92, 'vehicular', 'Cuota inicial de vehiculo de carga', 'desembolsado', 15000.00, 'Transporte', 'Transportes Anibal', 42, 9500.00, 4200.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('d2b8dd0b-ace4-4d83-bed8-38a33edf191a', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'a3df722e-9568-4292-ba60-8be66c213e80', '4c72b0a0-8bc1-4277-b9c9-69d12ca6b0d5', '43773379', 'NORMAL', 2, 14000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('862154e0-6a58-42b1-8e4a-73a97de2657c', 'CTA-43773379-7', 'a3df722e-9568-4292-ba60-8be66c213e80', 15000.00, 15000.00, 15000.00, 'vigente', CURRENT_DATE, 43.92, 18);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 1, '2026-07-18', 1098.07, 635.99, 462.08, 14364.01, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 2, '2026-08-18', 1098.07, 655.58, 442.49, 13708.43, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 3, '2026-09-18', 1098.07, 675.78, 422.3, 13032.66, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 4, '2026-10-18', 1098.07, 696.59, 401.48, 12336.06, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 5, '2026-11-18', 1098.07, 718.05, 380.02, 11618.01, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 6, '2026-12-18', 1098.07, 740.17, 357.9, 10877.84, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 7, '2027-01-18', 1098.07, 762.97, 335.1, 10114.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 8, '2027-02-18', 1098.07, 786.48, 311.59, 9328.39, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 9, '2027-03-18', 1098.07, 810.71, 287.37, 8517.68, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 10, '2027-04-18', 1098.07, 835.68, 262.39, 7682.0, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 11, '2027-05-18', 1098.07, 861.42, 236.65, 6820.58, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 12, '2027-06-18', 1098.07, 887.96, 210.11, 5932.62, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 13, '2027-07-18', 1098.07, 915.31, 182.76, 5017.3, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 14, '2027-08-18', 1098.07, 943.51, 154.56, 4073.79, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 15, '2027-09-18', 1098.07, 972.58, 125.5, 3101.21, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 16, '2027-10-18', 1098.07, 1002.54, 95.53, 2098.68, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 17, '2027-11-18', 1098.07, 1033.42, 64.65, 1065.26, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43773379-7', 18, '2027-12-18', 1098.07, 1065.26, 32.82, 0, 'pendiente');

-- ================= CASO 8 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('559a701e-8bf6-4528-9815-c6ad8abd71da', '40886086', 'Penelope', 'Apaza', '964110208', 'Avicola', 'Granja Penelope', 72, 8800.00, -12.1581, -75.1762, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '559a701e-8bf6-4528-9815-c6ad8abd71da', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -12.1581, -75.1762);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('0b4523c3-f494-412b-9fab-796f2527d632', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '559a701e-8bf6-4528-9815-c6ad8abd71da', 18000.00, 24, 43.92, 'hipotecaria', 'Ampliacion de galpon', 'desembolsado', 18000.00, 'Avicola', 'Granja Penelope', 72, 8800.00, 3600.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('f61072e3-7409-48a3-8343-5c0f554bc07b', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '559a701e-8bf6-4528-9815-c6ad8abd71da', '0b4523c3-f494-412b-9fab-796f2527d632', '40886086', 'NORMAL', 1, 6000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('1521fc1d-2e21-422a-8cf6-abbb9528eff0', 'CTA-40886086-8', '559a701e-8bf6-4528-9815-c6ad8abd71da', 18000.00, 18000.00, 18000.00, 'vigente', CURRENT_DATE, 43.92, 24);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 1, '2026-07-18', 1072.1, 517.6, 554.5, 17482.4, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 2, '2026-08-18', 1072.1, 533.54, 538.56, 16948.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 3, '2026-09-18', 1072.1, 549.98, 522.12, 16398.88, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 4, '2026-10-18', 1072.1, 566.92, 505.18, 15831.96, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 5, '2026-11-18', 1072.1, 584.39, 487.71, 15247.58, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 6, '2026-12-18', 1072.1, 602.39, 469.71, 14645.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 7, '2027-01-18', 1072.1, 620.94, 451.15, 14024.24, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 8, '2027-02-18', 1072.1, 640.07, 432.03, 13384.17, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 9, '2027-03-18', 1072.1, 659.79, 412.31, 12724.38, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 10, '2027-04-18', 1072.1, 680.12, 391.98, 12044.26, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 11, '2027-05-18', 1072.1, 701.07, 371.03, 11343.2, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 12, '2027-06-18', 1072.1, 722.66, 349.43, 10620.53, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 13, '2027-07-18', 1072.1, 744.93, 327.17, 9875.6, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 14, '2027-08-18', 1072.1, 767.87, 304.22, 9107.73, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 15, '2027-09-18', 1072.1, 791.53, 280.57, 8316.2, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 16, '2027-10-18', 1072.1, 815.91, 256.19, 7500.29, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 17, '2027-11-18', 1072.1, 841.05, 231.05, 6659.24, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 18, '2027-12-18', 1072.1, 866.96, 205.14, 5792.29, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 19, '2028-01-18', 1072.1, 893.66, 178.43, 4898.62, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 20, '2028-02-18', 1072.1, 921.19, 150.9, 3977.43, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 21, '2028-03-18', 1072.1, 949.57, 122.53, 3027.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 22, '2028-04-18', 1072.1, 978.82, 93.27, 2049.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 23, '2028-05-18', 1072.1, 1008.98, 63.12, 1040.06, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40886086-8', 24, '2028-06-18', 1072.1, 1040.06, 32.04, 0, 'pendiente');

-- ================= CASO 9 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('ba410c28-295c-4d0c-89c8-6d3776c8863c', '41990091', 'Heraclito', 'Ccahua', '964110209', 'Comercio', 'Importaciones Heraclito', 96, 12000.00, -12.0668, -75.2103, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'ba410c28-295c-4d0c-89c8-6d3776c8863c', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -12.0668, -75.2103);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('ec95c97c-af24-44a6-acf9-167c2a3930b9', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'ba410c28-295c-4d0c-89c8-6d3776c8863c', 20000.00, 36, 43.92, 'hipotecaria', 'Capital para nueva sucursal', 'desembolsado', 20000.00, 'Comercio', 'Importaciones Heraclito', 96, 12000.00, 5000.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('6d86dc25-fe50-4439-bd02-f6c05997be2f', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'ba410c28-295c-4d0c-89c8-6d3776c8863c', 'ec95c97c-af24-44a6-acf9-167c2a3930b9', '41990091', 'NORMAL', 2, 12000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('34faa930-08ad-4d7a-9131-233d4d84a84d', 'CTA-41990091-9', 'ba410c28-295c-4d0c-89c8-6d3776c8863c', 20000.00, 20000.00, 20000.00, 'vigente', CURRENT_DATE, 43.92, 36);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 1, '2026-07-18', 927.12, 311.01, 616.11, 19688.99, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 2, '2026-08-18', 927.12, 320.59, 606.53, 19368.4, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 3, '2026-09-18', 927.12, 330.47, 596.65, 19037.94, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 4, '2026-10-18', 927.12, 340.65, 586.47, 18697.29, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 5, '2026-11-18', 927.12, 351.14, 575.98, 18346.15, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 6, '2026-12-18', 927.12, 361.96, 565.16, 17984.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 7, '2027-01-18', 927.12, 373.11, 554.01, 17611.09, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 8, '2027-02-18', 927.12, 384.6, 542.52, 17226.49, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 9, '2027-03-18', 927.12, 396.45, 530.67, 16830.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 10, '2027-04-18', 927.12, 408.66, 518.46, 16421.38, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 11, '2027-05-18', 927.12, 421.25, 505.87, 16000.13, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 12, '2027-06-18', 927.12, 434.23, 492.89, 15565.9, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 13, '2027-07-18', 927.12, 447.6, 479.52, 15118.29, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 14, '2027-08-18', 927.12, 461.39, 465.73, 14656.9, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 15, '2027-09-18', 927.12, 475.61, 451.51, 14181.3, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 16, '2027-10-18', 927.12, 490.26, 436.86, 13691.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 17, '2027-11-18', 927.12, 505.36, 421.76, 13185.68, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 18, '2027-12-18', 927.12, 520.93, 406.19, 12664.75, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 19, '2028-01-18', 927.12, 536.98, 390.15, 12127.77, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 20, '2028-02-18', 927.12, 553.52, 373.6, 11574.26, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 21, '2028-03-18', 927.12, 570.57, 356.55, 11003.69, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 22, '2028-04-18', 927.12, 588.15, 338.98, 10415.54, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 23, '2028-05-18', 927.12, 606.26, 320.86, 9809.28, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 24, '2028-06-18', 927.12, 624.94, 302.18, 9184.34, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 25, '2028-07-18', 927.12, 644.19, 282.93, 8540.15, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 26, '2028-08-18', 927.12, 664.04, 263.08, 7876.11, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 27, '2028-09-18', 927.12, 684.49, 242.63, 7191.62, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 28, '2028-10-18', 927.12, 705.58, 221.54, 6486.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 29, '2028-11-18', 927.12, 727.31, 199.81, 5758.73, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 30, '2028-12-18', 927.12, 749.72, 177.4, 5009.01, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 31, '2029-01-18', 927.12, 772.82, 154.31, 4236.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 32, '2029-02-18', 927.12, 796.62, 130.5, 3439.57, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 33, '2029-03-18', 927.12, 821.16, 105.96, 2618.41, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 34, '2029-04-18', 927.12, 846.46, 80.66, 1771.95, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 35, '2029-05-18', 927.12, 872.53, 54.59, 899.41, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41990091-9', 36, '2029-06-18', 927.12, 899.41, 27.71, 0, 'pendiente');

-- ================= CASO 10 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('35a0e847-913e-4c68-b04a-50ca783f091e', '43003039', 'Cleopatra', 'Soto', '964110210', 'Farmacia', 'Botica Cleopatra', 66, 11000.00, -12.056, -75.287, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '35a0e847-913e-4c68-b04a-50ca783f091e', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -12.056, -75.287);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('70493577-5f6a-419e-aad2-3cd2e7b94d9e', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '35a0e847-913e-4c68-b04a-50ca783f091e', 25000.00, 24, 40.92, 'hipotecaria', 'Equipamiento y stock farmaceutico', 'desembolsado', 25000.00, 'Farmacia', 'Botica Cleopatra', 66, 11000.00, 4400.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('0dce4f6b-f92a-462e-b338-ad36e757b817', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '35a0e847-913e-4c68-b04a-50ca783f091e', '70493577-5f6a-419e-aad2-3cd2e7b94d9e', '43003039', 'NORMAL', 2, 14000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('f226a98e-f802-4d5d-9d71-4e749ece87a7', 'CTA-43003039-10', '35a0e847-913e-4c68-b04a-50ca783f091e', 25000.00, 25000.00, 25000.00, 'vigente', CURRENT_DATE, 40.92, 24);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 1, '2026-07-18', 1460.29, 735.35, 724.94, 24264.65, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 2, '2026-08-18', 1460.29, 756.67, 703.62, 23507.98, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 3, '2026-09-18', 1460.29, 778.62, 681.68, 22729.36, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 4, '2026-10-18', 1460.29, 801.19, 659.1, 21928.17, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 5, '2026-11-18', 1460.29, 824.43, 635.87, 21103.74, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 6, '2026-12-18', 1460.29, 848.33, 611.96, 20255.41, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 7, '2027-01-18', 1460.29, 872.93, 587.36, 19382.47, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 8, '2027-02-18', 1460.29, 898.25, 562.05, 18484.23, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 9, '2027-03-18', 1460.29, 924.29, 536.0, 17559.93, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 10, '2027-04-18', 1460.29, 951.1, 509.2, 16608.84, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 11, '2027-05-18', 1460.29, 978.67, 481.62, 15630.17, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 12, '2027-06-18', 1460.29, 1007.05, 453.24, 14623.11, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 13, '2027-07-18', 1460.29, 1036.26, 424.04, 13586.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 14, '2027-08-18', 1460.29, 1066.31, 393.99, 12520.55, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 15, '2027-09-18', 1460.29, 1097.23, 363.07, 11423.32, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 16, '2027-10-18', 1460.29, 1129.04, 331.25, 10294.28, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 17, '2027-11-18', 1460.29, 1161.78, 298.51, 9132.5, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 18, '2027-12-18', 1460.29, 1195.47, 264.82, 7937.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 19, '2028-01-18', 1460.29, 1230.14, 230.16, 6706.89, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 20, '2028-02-18', 1460.29, 1265.81, 194.48, 5441.08, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 21, '2028-03-18', 1460.29, 1302.51, 157.78, 4138.57, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 22, '2028-04-18', 1460.29, 1340.28, 120.01, 2798.29, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 23, '2028-05-18', 1460.29, 1379.15, 81.14, 1419.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43003039-10', 24, '2028-06-18', 1460.29, 1419.14, 41.15, 0, 'pendiente');

-- ================= CASO 11 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('34e1fc66-3311-45d4-8732-6c1e7b88b545', '40110010', 'Esquilo', 'Ramos', '964110211', 'Bodega', 'Minimarket Esquilo', 24, 1900.00, -12.1339, -75.209, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '34e1fc66-3311-45d4-8732-6c1e7b88b545', CURRENT_DATE, 'NUEVA_SOLICITUD', 'normal', 'visitado', -12.1339, -75.209);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('923e30aa-9d80-48d5-aacc-bf02b193afb3', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '34e1fc66-3311-45d4-8732-6c1e7b88b545', 2000.00, 12, 43.92, 'sin garantia', 'Compra de congeladora', 'desembolsado', 2000.00, 'Bodega', 'Minimarket Esquilo', 24, 1900.00, 800.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('8a9794a4-572d-4a05-bcb9-09be44a3fa3a', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '34e1fc66-3311-45d4-8732-6c1e7b88b545', '923e30aa-9d80-48d5-aacc-bf02b193afb3', '40110010', 'NORMAL', 1, 4500.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('71d54e0a-635e-46fb-b43e-2e851dde0cfc', 'CTA-40110010-11', '34e1fc66-3311-45d4-8732-6c1e7b88b545', 2000.00, 2000.00, 2000.00, 'vigente', CURRENT_DATE, 43.92, 12);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 1, '2026-07-18', 201.89, 140.28, 61.61, 1859.72, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 2, '2026-08-18', 201.89, 144.6, 57.29, 1715.12, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 3, '2026-09-18', 201.89, 149.06, 52.84, 1566.06, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 4, '2026-10-18', 201.89, 153.65, 48.24, 1412.41, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 5, '2026-11-18', 201.89, 158.38, 43.51, 1254.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 6, '2026-12-18', 201.89, 163.26, 38.63, 1090.77, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 7, '2027-01-18', 201.89, 168.29, 33.6, 922.48, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 8, '2027-02-18', 201.89, 173.47, 28.42, 749.01, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 9, '2027-03-18', 201.89, 178.82, 23.07, 570.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 10, '2027-04-18', 201.89, 184.33, 17.57, 385.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 11, '2027-05-18', 201.89, 190.0, 11.89, 195.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40110010-11', 12, '2027-06-18', 201.89, 195.86, 6.03, 0, 'pendiente');

-- ================= CASO 12 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('95342f3b-42ba-4216-9228-5c527f6ebf20', '41226021', 'Ariadna', 'Quispe', '964110212', 'Peluqueria', 'Estilos Ariadna', 40, 3300.00, -12.0573, -75.2161, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '95342f3b-42ba-4216-9228-5c527f6ebf20', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0573, -75.2161);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('07b9c8a3-99bf-45c3-b7b1-f6bfbb7de2a7', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '95342f3b-42ba-4216-9228-5c527f6ebf20', 4000.00, 18, 43.92, 'sin garantia', 'Mobiliario y equipos de salon', 'desembolsado', 4000.00, 'Peluqueria', 'Estilos Ariadna', 40, 3300.00, 1300.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('34023b04-36e9-4b66-9c2e-7f34a2d38b07', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '95342f3b-42ba-4216-9228-5c527f6ebf20', '07b9c8a3-99bf-45c3-b7b1-f6bfbb7de2a7', '41226021', 'NORMAL', 2, 12000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('d85e19c6-5465-4cc3-8666-180590899291', 'CTA-41226021-12', '95342f3b-42ba-4216-9228-5c527f6ebf20', 4000.00, 4000.00, 4000.00, 'vigente', CURRENT_DATE, 43.92, 18);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 1, '2026-07-18', 292.82, 169.6, 123.22, 3830.4, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 2, '2026-08-18', 292.82, 174.82, 118.0, 3655.58, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 3, '2026-09-18', 292.82, 180.21, 112.61, 3475.37, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 4, '2026-10-18', 292.82, 185.76, 107.06, 3289.62, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 5, '2026-11-18', 292.82, 191.48, 101.34, 3098.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 6, '2026-12-18', 292.82, 197.38, 95.44, 2900.76, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 7, '2027-01-18', 292.82, 203.46, 89.36, 2697.3, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 8, '2027-02-18', 292.82, 209.73, 83.09, 2487.57, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 9, '2027-03-18', 292.82, 216.19, 76.63, 2271.38, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 10, '2027-04-18', 292.82, 222.85, 69.97, 2048.53, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 11, '2027-05-18', 292.82, 229.71, 63.11, 1818.82, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 12, '2027-06-18', 292.82, 236.79, 56.03, 1582.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 13, '2027-07-18', 292.82, 244.08, 48.74, 1337.95, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 14, '2027-08-18', 292.82, 251.6, 41.22, 1086.34, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 15, '2027-09-18', 292.82, 259.35, 33.47, 826.99, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 16, '2027-10-18', 292.82, 267.34, 25.48, 559.65, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 17, '2027-11-18', 292.82, 275.58, 17.24, 284.07, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226021-12', 18, '2027-12-18', 292.82, 284.07, 8.75, 0, 'pendiente');

-- ================= CASO 13 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('10abbbb3-e7c0-4465-9e80-60b50a1f8188', '43336033', 'Sofocles', 'Huanca', '964110213', 'Panaderia', 'Panaderia Sofocles', 58, 5600.00, -12.0228, -75.3134, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '10abbbb3-e7c0-4465-9e80-60b50a1f8188', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0228, -75.3134);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('d7c7d0b4-43ef-4b20-b36f-6e71fec39c7f', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '10abbbb3-e7c0-4465-9e80-60b50a1f8188', 6000.00, 12, 40.92, 'sin garantia', 'Horno rotativo', 'desembolsado', 6000.00, 'Panaderia', 'Panaderia Sofocles', 58, 5600.00, 2300.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('e6ec9411-4b8f-459c-9d4a-ff8910c638a0', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '10abbbb3-e7c0-4465-9e80-60b50a1f8188', 'd7c7d0b4-43ef-4b20-b36f-6e71fec39c7f', '43336033', 'NORMAL', 0, 0.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('f9629fc1-e8cd-4d8c-a7f2-099a22e18a3d', 'CTA-43336033-13', '10abbbb3-e7c0-4465-9e80-60b50a1f8188', 6000.00, 6000.00, 6000.00, 'vigente', CURRENT_DATE, 40.92, 12);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 1, '2026-07-18', 599.17, 425.19, 173.99, 5574.81, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 2, '2026-08-18', 599.17, 437.51, 161.66, 5137.3, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 3, '2026-09-18', 599.17, 450.2, 148.97, 4687.1, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 4, '2026-10-18', 599.17, 463.26, 135.91, 4223.84, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 5, '2026-11-18', 599.17, 476.69, 122.48, 3747.15, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 6, '2026-12-18', 599.17, 490.51, 108.66, 3256.64, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 7, '2027-01-18', 599.17, 504.74, 94.43, 2751.9, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 8, '2027-02-18', 599.17, 519.37, 79.8, 2232.53, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 9, '2027-03-18', 599.17, 534.43, 64.74, 1698.09, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 10, '2027-04-18', 599.17, 549.93, 49.24, 1148.16, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 11, '2027-05-18', 599.17, 565.88, 33.29, 582.29, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43336033-13', 12, '2027-06-18', 599.17, 582.29, 16.88, 0, 'pendiente');

-- ================= CASO 14 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('a0d58cd0-db8c-48fa-983a-cac311b7d751', '40550055', 'Casiopea', 'Torres', '964110214', 'Mecanica', 'Taller Casiopea', 50, 7400.00, -12.0512, -75.2451, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'a0d58cd0-db8c-48fa-983a-cac311b7d751', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0512, -75.2451);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('8459747a-395c-44d4-a30d-5e3da191fea9', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'a0d58cd0-db8c-48fa-983a-cac311b7d751', 7500.00, 6, 43.92, 'sin garantia', 'Herramienta neumatica', 'desembolsado', 7500.00, 'Mecanica', 'Taller Casiopea', 50, 7400.00, 3000.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('64708d0e-c77a-42fd-bd90-3b2ed837910d', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'a0d58cd0-db8c-48fa-983a-cac311b7d751', '8459747a-395c-44d4-a30d-5e3da191fea9', '40550055', 'DEFICIENTE', 2, 16000.00, 45, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('12a64749-e7b3-435d-8d4a-3dd67c505ad1', 'CTA-40550055-14', 'a0d58cd0-db8c-48fa-983a-cac311b7d751', 7500.00, 7500.00, 7500.00, 'vigente', CURRENT_DATE, 43.92, 6);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40550055-14', 1, '2026-07-18', 1388.18, 1157.14, 231.04, 6342.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40550055-14', 2, '2026-08-18', 1388.18, 1192.78, 195.4, 5150.08, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40550055-14', 3, '2026-09-18', 1388.18, 1229.53, 158.65, 3920.55, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40550055-14', 4, '2026-10-18', 1388.18, 1267.41, 120.77, 2653.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40550055-14', 5, '2026-11-18', 1388.18, 1306.45, 81.73, 1346.69, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40550055-14', 6, '2026-12-18', 1388.18, 1346.69, 41.49, 0, 'pendiente');

-- ================= CASO 15 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('d2c6d13a-123d-47c9-9ab0-afe0c6531ab7', '41669166', 'Aristofanes', 'Cruz', '964110215', 'Agropecuario', 'Insumos Aristofanes', 78, 8200.00, -11.976, -75.3361, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'd2c6d13a-123d-47c9-9ab0-afe0c6531ab7', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -11.976, -75.3361);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('f344c015-9e9f-458f-822e-8bfaf4a60803', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'd2c6d13a-123d-47c9-9ab0-afe0c6531ab7', 9000.00, 24, 43.92, 'hipotecaria', 'Capital para campana agricola', 'desembolsado', 9000.00, 'Agropecuario', 'Insumos Aristofanes', 78, 8200.00, 3300.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('8163fe90-6b00-462f-851e-7c5dacb07184', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'd2c6d13a-123d-47c9-9ab0-afe0c6531ab7', 'f344c015-9e9f-458f-822e-8bfaf4a60803', '41669166', 'NORMAL', 1, 6000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('a1d8054f-188b-49e2-932d-88b9fda4984c', 'CTA-41669166-15', 'd2c6d13a-123d-47c9-9ab0-afe0c6531ab7', 9000.00, 9000.00, 9000.00, 'vigente', CURRENT_DATE, 43.92, 24);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 1, '2026-07-18', 536.05, 258.8, 277.25, 8741.2, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 2, '2026-08-18', 536.05, 266.77, 269.28, 8474.43, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 3, '2026-09-18', 536.05, 274.99, 261.06, 8199.44, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 4, '2026-10-18', 536.05, 283.46, 252.59, 7915.98, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 5, '2026-11-18', 536.05, 292.19, 243.86, 7623.79, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 6, '2026-12-18', 536.05, 301.19, 234.86, 7322.59, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 7, '2027-01-18', 536.05, 310.47, 225.58, 7012.12, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 8, '2027-02-18', 536.05, 320.04, 216.01, 6692.09, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 9, '2027-03-18', 536.05, 329.9, 206.15, 6362.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 10, '2027-04-18', 536.05, 340.06, 195.99, 6022.13, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 11, '2027-05-18', 536.05, 350.53, 185.52, 5671.6, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 12, '2027-06-18', 536.05, 361.33, 174.72, 5310.27, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 13, '2027-07-18', 536.05, 372.46, 163.59, 4937.8, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 14, '2027-08-18', 536.05, 383.94, 152.11, 4553.87, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 15, '2027-09-18', 536.05, 395.76, 140.28, 4158.1, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 16, '2027-10-18', 536.05, 407.96, 128.09, 3750.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 17, '2027-11-18', 536.05, 420.52, 115.53, 3329.62, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 18, '2027-12-18', 536.05, 433.48, 102.57, 2896.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 19, '2028-01-18', 536.05, 446.83, 89.22, 2449.31, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 20, '2028-02-18', 536.05, 460.6, 75.45, 1988.71, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 21, '2028-03-18', 536.05, 474.79, 61.26, 1513.93, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 22, '2028-04-18', 536.05, 489.41, 46.64, 1024.52, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 23, '2028-05-18', 536.05, 504.49, 31.56, 520.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41669166-15', 24, '2028-06-18', 536.05, 520.03, 16.02, 0, 'pendiente');

-- ================= CASO 16 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('1e0d9d5b-41ad-4387-8ea6-687db287ca4b', '43880088', 'Calipso', 'Mendoza', '964110216', 'Calzado', 'Calzados Calipso', 62, 7900.00, -12.0689, -75.2055, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '1e0d9d5b-41ad-4387-8ea6-687db287ca4b', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0689, -75.2055);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('1eff987b-332b-4f15-a543-820e8b4a26d4', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '1e0d9d5b-41ad-4387-8ea6-687db287ca4b', 11000.00, 18, 40.92, 'hipotecaria', 'Compra de cuero y maquinaria', 'desembolsado', 11000.00, 'Calzado', 'Calzados Calipso', 62, 7900.00, 3100.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('5d1eeb6c-32b1-4edb-9e3f-3bc99191694f', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '1e0d9d5b-41ad-4387-8ea6-687db287ca4b', '1eff987b-332b-4f15-a543-820e8b4a26d4', '43880088', 'CPP', 1, 9000.00, 20, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('2bc00cce-f370-4758-b733-5d6ee6ee8e1b', 'CTA-43880088-16', '1e0d9d5b-41ad-4387-8ea6-687db287ca4b', 11000.00, 11000.00, 11000.00, 'vigente', CURRENT_DATE, 40.92, 18);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 1, '2026-07-18', 793.03, 474.06, 318.97, 10525.94, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 2, '2026-08-18', 793.03, 487.81, 305.23, 10038.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 3, '2026-09-18', 793.03, 501.95, 291.08, 9536.18, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 4, '2026-10-18', 793.03, 516.51, 276.53, 9019.68, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 5, '2026-11-18', 793.03, 531.48, 261.55, 8488.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 6, '2026-12-18', 793.03, 546.9, 246.14, 7941.3, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 7, '2027-01-18', 793.03, 562.75, 230.28, 7378.54, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 8, '2027-02-18', 793.03, 579.07, 213.96, 6799.47, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 9, '2027-03-18', 793.03, 595.86, 197.17, 6203.61, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 10, '2027-04-18', 793.03, 613.14, 179.89, 5590.46, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 11, '2027-05-18', 793.03, 630.92, 162.11, 4959.54, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 12, '2027-06-18', 793.03, 649.22, 143.82, 4310.32, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 13, '2027-07-18', 793.03, 668.04, 124.99, 3642.28, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 14, '2027-08-18', 793.03, 687.42, 105.62, 2954.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 15, '2027-09-18', 793.03, 707.35, 85.68, 2247.51, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 16, '2027-10-18', 793.03, 727.86, 65.17, 1519.65, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 17, '2027-11-18', 793.03, 748.97, 44.07, 770.69, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43880088-16', 18, '2027-12-18', 793.03, 770.69, 22.35, 0, 'pendiente');

-- ================= CASO 17 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('1b2857ea-8947-4556-b88b-3803078ca201', '40119019', 'Demetrio', 'Quispe', '964110217', 'Comercio', 'Mayorista Demetrio', 90, 11500.00, -11.7752, -75.4995, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '1b2857ea-8947-4556-b88b-3803078ca201', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -11.7752, -75.4995);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('23b60f3a-f4a7-43bc-a6ab-11ae279332c3', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '1b2857ea-8947-4556-b88b-3803078ca201', 13500.00, 12, 43.92, 'hipotecaria', 'Reposicion de inventario mayorista', 'desembolsado', 13500.00, 'Comercio', 'Mayorista Demetrio', 90, 11500.00, 4700.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('8f3a31d0-5fb6-4c77-86c4-fd530e7fff0a', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '1b2857ea-8947-4556-b88b-3803078ca201', '23b60f3a-f4a7-43bc-a6ab-11ae279332c3', '40119019', 'NORMAL', 2, 14000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('7677ee87-71f0-40a0-8246-e3cebde73092', 'CTA-40119019-17', '1b2857ea-8947-4556-b88b-3803078ca201', 13500.00, 13500.00, 13500.00, 'vigente', CURRENT_DATE, 43.92, 12);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 1, '2026-07-18', 1362.77, 946.89, 415.88, 12553.11, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 2, '2026-08-18', 1362.77, 976.06, 386.71, 11577.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 3, '2026-09-18', 1362.77, 1006.13, 356.64, 10570.91, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 4, '2026-10-18', 1362.77, 1037.13, 325.64, 9533.79, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 5, '2026-11-18', 1362.77, 1069.07, 293.69, 8464.71, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 6, '2026-12-18', 1362.77, 1102.01, 260.76, 7362.71, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 7, '2027-01-18', 1362.77, 1135.96, 226.81, 6226.75, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 8, '2027-02-18', 1362.77, 1170.95, 191.82, 5055.8, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 9, '2027-03-18', 1362.77, 1207.02, 155.75, 3848.78, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 10, '2027-04-18', 1362.77, 1244.2, 118.56, 2604.57, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 11, '2027-05-18', 1362.77, 1282.53, 80.24, 1322.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40119019-17', 12, '2027-06-18', 1362.77, 1322.04, 40.73, 0, 'pendiente');

-- ================= CASO 18 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('1fb2a897-50bc-4b7a-b6d3-4cc626d79728', '41226126', 'Antigona', 'Flores', '964110218', 'Restaurante', 'Recreo Antigona', 70, 9200.00, -11.9201, -75.311, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '1fb2a897-50bc-4b7a-b6d3-4cc626d79728', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -11.9201, -75.311);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('0dd78b2c-003d-4daf-b56e-7a1b39d5447f', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '1fb2a897-50bc-4b7a-b6d3-4cc626d79728', 16000.00, 36, 43.92, 'hipotecaria', 'Ampliacion y remodelacion', 'desembolsado', 16000.00, 'Restaurante', 'Recreo Antigona', 70, 9200.00, 3900.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('9b48a1ab-c3a8-4b27-b7bc-ec7f3c31c0f1', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '1fb2a897-50bc-4b7a-b6d3-4cc626d79728', '0dd78b2c-003d-4daf-b56e-7a1b39d5447f', '41226126', 'NORMAL', 1, 6000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('d96c1162-f386-4738-9529-9e37390602be', 'CTA-41226126-18', '1fb2a897-50bc-4b7a-b6d3-4cc626d79728', 16000.00, 16000.00, 16000.00, 'vigente', CURRENT_DATE, 43.92, 36);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 1, '2026-07-18', 741.7, 248.81, 492.89, 15751.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 2, '2026-08-18', 741.7, 256.47, 485.22, 15494.72, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 3, '2026-09-18', 741.7, 264.37, 477.32, 15230.35, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 4, '2026-10-18', 741.7, 272.52, 469.18, 14957.83, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 5, '2026-11-18', 741.7, 280.91, 460.78, 14676.92, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 6, '2026-12-18', 741.7, 289.57, 452.13, 14387.36, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 7, '2027-01-18', 741.7, 298.49, 443.21, 14088.87, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 8, '2027-02-18', 741.7, 307.68, 434.02, 13781.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 9, '2027-03-18', 741.7, 317.16, 424.54, 13464.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 10, '2027-04-18', 741.7, 326.93, 414.77, 13137.1, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 11, '2027-05-18', 741.7, 337.0, 404.7, 12800.1, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 12, '2027-06-18', 741.7, 347.38, 394.31, 12452.72, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 13, '2027-07-18', 741.7, 358.08, 383.61, 12094.64, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 14, '2027-08-18', 741.7, 369.11, 372.58, 11725.52, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 15, '2027-09-18', 741.7, 380.48, 361.21, 11345.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 16, '2027-10-18', 741.7, 392.21, 349.49, 10952.83, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 17, '2027-11-18', 741.7, 404.29, 337.41, 10548.54, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 18, '2027-12-18', 741.7, 416.74, 324.95, 10131.8, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 19, '2028-01-18', 741.7, 429.58, 312.12, 9702.22, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 20, '2028-02-18', 741.7, 442.81, 298.88, 9259.41, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 21, '2028-03-18', 741.7, 456.46, 285.24, 8802.95, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 22, '2028-04-18', 741.7, 470.52, 271.18, 8332.43, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 23, '2028-05-18', 741.7, 485.01, 256.69, 7847.42, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 24, '2028-06-18', 741.7, 499.95, 241.74, 7347.47, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 25, '2028-07-18', 741.7, 515.35, 226.34, 6832.12, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 26, '2028-08-18', 741.7, 531.23, 210.47, 6300.89, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 27, '2028-09-18', 741.7, 547.59, 194.1, 5753.3, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 28, '2028-10-18', 741.7, 564.46, 177.23, 5188.83, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 29, '2028-11-18', 741.7, 581.85, 159.85, 4606.98, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 30, '2028-12-18', 741.7, 599.78, 141.92, 4007.21, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 31, '2029-01-18', 741.7, 618.25, 123.44, 3388.95, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 32, '2029-02-18', 741.7, 637.3, 104.4, 2751.66, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 33, '2029-03-18', 741.7, 656.93, 84.77, 2094.73, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 34, '2029-04-18', 741.7, 677.17, 64.53, 1417.56, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 35, '2029-05-18', 741.7, 698.03, 43.67, 719.53, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41226126-18', 36, '2029-06-18', 741.7, 719.53, 22.17, 0, 'pendiente');

-- ================= CASO 19 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('c3e019c0-fdb8-45e3-9ee0-8530ca7240ec', '43339033', 'Pitagoras', 'Rojas', '964110219', 'Ferreteria', 'Ferreteria Pitagoras', 100, 13000.00, -12.0599, -75.2143, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'c3e019c0-fdb8-45e3-9ee0-8530ca7240ec', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -12.0599, -75.2143);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('5793f9a7-b469-4319-9479-b09312d0f970', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'c3e019c0-fdb8-45e3-9ee0-8530ca7240ec', 17000.00, 24, 40.92, 'hipotecaria', 'Compra de stock estructural', 'desembolsado', 17000.00, 'Ferreteria', 'Ferreteria Pitagoras', 100, 13000.00, 5200.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('2f3685c8-5c1e-41ae-98a1-d5f906f937df', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'c3e019c0-fdb8-45e3-9ee0-8530ca7240ec', '5793f9a7-b469-4319-9479-b09312d0f970', '43339033', 'NORMAL', 0, 0.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('074837aa-a23a-4dd3-a7a2-86828b253690', 'CTA-43339033-19', 'c3e019c0-fdb8-45e3-9ee0-8530ca7240ec', 17000.00, 17000.00, 17000.00, 'vigente', CURRENT_DATE, 40.92, 24);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 1, '2026-07-18', 993.0, 500.04, 492.96, 16499.96, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 2, '2026-08-18', 993.0, 514.54, 478.46, 15985.42, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 3, '2026-09-18', 993.0, 529.46, 463.54, 15455.96, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 4, '2026-10-18', 993.0, 544.81, 448.19, 14911.15, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 5, '2026-11-18', 993.0, 560.61, 432.39, 14350.54, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 6, '2026-12-18', 993.0, 576.87, 416.13, 13773.68, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 7, '2027-01-18', 993.0, 593.59, 399.4, 13180.08, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 8, '2027-02-18', 993.0, 610.81, 382.19, 12569.27, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 9, '2027-03-18', 993.0, 628.52, 364.48, 11940.76, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 10, '2027-04-18', 993.0, 646.74, 346.25, 11294.01, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 11, '2027-05-18', 993.0, 665.5, 327.5, 10628.51, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 12, '2027-06-18', 993.0, 684.8, 308.2, 9943.72, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 13, '2027-07-18', 993.0, 704.65, 288.34, 9239.06, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 14, '2027-08-18', 993.0, 725.09, 267.91, 8513.97, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 15, '2027-09-18', 993.0, 746.11, 246.89, 7767.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 16, '2027-10-18', 993.0, 767.75, 225.25, 7000.11, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 17, '2027-11-18', 993.0, 790.01, 202.99, 6210.1, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 18, '2027-12-18', 993.0, 812.92, 180.08, 5397.18, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 19, '2028-01-18', 993.0, 836.49, 156.51, 4560.69, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 20, '2028-02-18', 993.0, 860.75, 132.25, 3699.94, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 21, '2028-03-18', 993.0, 885.71, 107.29, 2814.23, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 22, '2028-04-18', 993.0, 911.39, 81.61, 1902.84, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 23, '2028-05-18', 993.0, 937.82, 55.18, 965.02, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43339033-19', 24, '2028-06-18', 993.0, 965.02, 27.98, 0, 'pendiente');

-- ================= CASO 20 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('3b5a9195-5b67-4b55-8808-915df8591d83', '40556056', 'Berenice', 'Apaza', '964110220', 'Textil', 'Tejidos Berenice', 46, 8600.00, -11.9871, -75.2899, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '3b5a9195-5b67-4b55-8808-915df8591d83', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -11.9871, -75.2899);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('3cd5bdd1-ee09-4b3e-9ad1-7bdd0beae81b', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '3b5a9195-5b67-4b55-8808-915df8591d83', 19000.00, 18, 43.92, 'hipotecaria', 'Maquinaria de tejido plano', 'desembolsado', 19000.00, 'Textil', 'Tejidos Berenice', 46, 8600.00, 3500.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('ea943b9c-7786-4f03-92fe-ea54a1ec65ef', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '3b5a9195-5b67-4b55-8808-915df8591d83', '3cd5bdd1-ee09-4b3e-9ad1-7bdd0beae81b', '40556056', 'NORMAL', 1, 6000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('8c257205-7ca3-4c97-98c5-e581843af8c0', 'CTA-40556056-20', '3b5a9195-5b67-4b55-8808-915df8591d83', 19000.00, 19000.00, 19000.00, 'vigente', CURRENT_DATE, 43.92, 18);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 1, '2026-07-18', 1390.89, 805.59, 585.31, 18194.41, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 2, '2026-08-18', 1390.89, 830.4, 560.49, 17364.01, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 3, '2026-09-18', 1390.89, 855.98, 534.91, 16508.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 4, '2026-10-18', 1390.89, 882.35, 508.54, 15625.68, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 5, '2026-11-18', 1390.89, 909.53, 481.36, 14716.15, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 6, '2026-12-18', 1390.89, 937.55, 453.34, 13778.59, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 7, '2027-01-18', 1390.89, 966.43, 424.46, 12812.16, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 8, '2027-02-18', 1390.89, 996.21, 394.69, 11815.96, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 9, '2027-03-18', 1390.89, 1026.89, 364.0, 10789.06, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 10, '2027-04-18', 1390.89, 1058.53, 332.36, 9730.53, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 11, '2027-05-18', 1390.89, 1091.14, 299.75, 8639.4, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 12, '2027-06-18', 1390.89, 1124.75, 266.14, 7514.65, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 13, '2027-07-18', 1390.89, 1159.4, 231.49, 6355.25, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 14, '2027-08-18', 1390.89, 1195.11, 195.78, 5160.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 15, '2027-09-18', 1390.89, 1231.93, 158.96, 3928.21, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 16, '2027-10-18', 1390.89, 1269.88, 121.01, 2658.32, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 17, '2027-11-18', 1390.89, 1309.0, 81.89, 1349.32, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40556056-20', 18, '2027-12-18', 1390.89, 1349.32, 41.57, 0, 'pendiente');

-- ================= CASO 21 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('ce50ed96-d7a3-4e92-82db-1e3b43bf767c', '43889089', 'Anaxagoras', 'Huaman', '964110221', 'Transporte', 'Carga Anaxagoras', 84, 14000.00, -12.0644, -75.2088, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'ce50ed96-d7a3-4e92-82db-1e3b43bf767c', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -12.0644, -75.2088);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('62754b0b-3721-4ab7-bb43-67625e3fbded', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'ce50ed96-d7a3-4e92-82db-1e3b43bf767c', 22000.00, 36, 43.92, 'vehicular', 'Cuota inicial de camion', 'desembolsado', 22000.00, 'Transporte', 'Carga Anaxagoras', 84, 14000.00, 5800.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('93f2d17b-150d-46fb-a052-b919bca07d2b', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'ce50ed96-d7a3-4e92-82db-1e3b43bf767c', '62754b0b-3721-4ab7-bb43-67625e3fbded', '43889089', 'NORMAL', 2, 14000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('3d561460-e42f-4a57-8840-01ceade5634b', 'CTA-43889089-21', 'ce50ed96-d7a3-4e92-82db-1e3b43bf767c', 22000.00, 22000.00, 22000.00, 'vigente', CURRENT_DATE, 43.92, 36);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 1, '2026-07-18', 1019.83, 342.11, 677.72, 21657.89, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 2, '2026-08-18', 1019.83, 352.65, 667.18, 21305.24, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 3, '2026-09-18', 1019.83, 363.51, 656.32, 20941.73, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 4, '2026-10-18', 1019.83, 374.71, 645.12, 20567.02, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 5, '2026-11-18', 1019.83, 386.25, 633.58, 20180.77, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 6, '2026-12-18', 1019.83, 398.15, 621.68, 19782.61, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 7, '2027-01-18', 1019.83, 410.42, 609.41, 19372.2, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 8, '2027-02-18', 1019.83, 423.06, 596.77, 18949.13, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 9, '2027-03-18', 1019.83, 436.09, 583.74, 18513.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 10, '2027-04-18', 1019.83, 449.53, 570.31, 18063.51, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 11, '2027-05-18', 1019.83, 463.38, 556.46, 17600.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 12, '2027-06-18', 1019.83, 477.65, 542.18, 17122.49, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 13, '2027-07-18', 1019.83, 492.36, 527.47, 16630.12, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 14, '2027-08-18', 1019.83, 507.53, 512.3, 16122.59, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 15, '2027-09-18', 1019.83, 523.17, 496.67, 15599.43, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 16, '2027-10-18', 1019.83, 539.28, 480.55, 15060.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 17, '2027-11-18', 1019.83, 555.9, 463.94, 14504.25, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 18, '2027-12-18', 1019.83, 573.02, 446.81, 13931.23, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 19, '2028-01-18', 1019.83, 590.67, 429.16, 13340.55, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 20, '2028-02-18', 1019.83, 608.87, 410.96, 12731.68, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 21, '2028-03-18', 1019.83, 627.63, 392.21, 12104.06, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 22, '2028-04-18', 1019.83, 646.96, 372.87, 11457.1, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 23, '2028-05-18', 1019.83, 666.89, 352.94, 10790.21, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 24, '2028-06-18', 1019.83, 687.43, 332.4, 10102.77, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 25, '2028-07-18', 1019.83, 708.61, 311.22, 9394.16, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 26, '2028-08-18', 1019.83, 730.44, 289.39, 8663.72, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 27, '2028-09-18', 1019.83, 752.94, 266.89, 7910.78, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 28, '2028-10-18', 1019.83, 776.14, 243.7, 7134.64, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 29, '2028-11-18', 1019.83, 800.05, 219.79, 6334.6, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 30, '2028-12-18', 1019.83, 824.69, 195.14, 5509.91, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 31, '2029-01-18', 1019.83, 850.1, 169.74, 4659.81, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 32, '2029-02-18', 1019.83, 876.28, 143.55, 3783.53, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 33, '2029-03-18', 1019.83, 903.28, 116.55, 2880.25, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 34, '2029-04-18', 1019.83, 931.1, 88.73, 1949.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 35, '2029-05-18', 1019.83, 959.79, 60.04, 989.35, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-43889089-21', 36, '2029-06-18', 1019.83, 989.35, 30.48, 0, 'pendiente');

-- ================= CASO 22 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('10d54f44-3159-404a-b297-5b89dd9ed15e', '41003001', 'Climene', 'Vargas', '964110222', 'Avicola', 'Avicola Climene', 76, 13500.00, -12.156, -75.179, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '10d54f44-3159-404a-b297-5b89dd9ed15e', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -12.156, -75.179);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('c428e574-47f4-436f-a91b-669a5ea05e94', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '10d54f44-3159-404a-b297-5b89dd9ed15e', 24000.00, 24, 40.92, 'hipotecaria', 'Equipamiento de planta', 'desembolsado', 24000.00, 'Avicola', 'Avicola Climene', 76, 13500.00, 5500.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('c43594fb-41a4-4b16-bfff-1e3294f06063', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '10d54f44-3159-404a-b297-5b89dd9ed15e', 'c428e574-47f4-436f-a91b-669a5ea05e94', '41003001', 'NORMAL', 2, 12000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('4126c9a7-32fa-47ab-bc6e-f375f90a6041', 'CTA-41003001-22', '10d54f44-3159-404a-b297-5b89dd9ed15e', 24000.00, 24000.00, 24000.00, 'vigente', CURRENT_DATE, 40.92, 24);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 1, '2026-07-18', 1401.88, 705.94, 695.94, 23294.06, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 2, '2026-08-18', 1401.88, 726.41, 675.47, 22567.66, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 3, '2026-09-18', 1401.88, 747.47, 654.41, 21820.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 4, '2026-10-18', 1401.88, 769.15, 632.73, 21051.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 5, '2026-11-18', 1401.88, 791.45, 610.43, 20259.59, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 6, '2026-12-18', 1401.88, 814.4, 587.48, 19445.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 7, '2027-01-18', 1401.88, 838.02, 563.86, 18607.17, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 8, '2027-02-18', 1401.88, 862.32, 539.56, 17744.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 9, '2027-03-18', 1401.88, 887.32, 514.56, 16857.54, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 10, '2027-04-18', 1401.88, 913.05, 488.83, 15944.49, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 11, '2027-05-18', 1401.88, 939.53, 462.35, 15004.96, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 12, '2027-06-18', 1401.88, 966.77, 435.11, 14038.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 13, '2027-07-18', 1401.88, 994.81, 407.07, 13043.38, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 14, '2027-08-18', 1401.88, 1023.65, 378.23, 12019.73, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 15, '2027-09-18', 1401.88, 1053.34, 348.54, 10966.39, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 16, '2027-10-18', 1401.88, 1083.88, 318.0, 9882.51, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 17, '2027-11-18', 1401.88, 1115.31, 286.57, 8767.2, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 18, '2027-12-18', 1401.88, 1147.65, 254.23, 7619.55, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 19, '2028-01-18', 1401.88, 1180.93, 220.95, 6438.62, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 20, '2028-02-18', 1401.88, 1215.18, 186.7, 5223.44, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 21, '2028-03-18', 1401.88, 1250.41, 151.47, 3973.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 22, '2028-04-18', 1401.88, 1286.67, 115.21, 2686.36, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 23, '2028-05-18', 1401.88, 1323.98, 77.9, 1362.37, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41003001-22', 24, '2028-06-18', 1401.88, 1362.37, 39.51, 0, 'pendiente');

-- ================= CASO 23 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('f7a06c61-f7f6-404b-8b2a-f45538f482cb', '40115011', 'Epaminondas', 'Soto', '964110223', 'Bodega', 'Bodega Epaminondas', 28, 2600.00, -12.1701, -75.1611, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'f7a06c61-f7f6-404b-8b2a-f45538f482cb', CURRENT_DATE, 'NUEVA_SOLICITUD', 'normal', 'visitado', -12.1701, -75.1611);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('e7bbfbce-7da6-4c4b-ad45-cfae64ef3d54', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'f7a06c61-f7f6-404b-8b2a-f45538f482cb', 1500.00, 6, 43.92, 'sin garantia', 'Compra de vitrinas', 'desembolsado', 1500.00, 'Bodega', 'Bodega Epaminondas', 28, 2600.00, 1000.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('4eb1ad2e-cebf-4bed-8230-772b0fe4e9bd', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'f7a06c61-f7f6-404b-8b2a-f45538f482cb', 'e7bbfbce-7da6-4c4b-ad45-cfae64ef3d54', '40115011', 'NORMAL', 2, 12000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('ac60a373-c3dd-4d04-8016-4cdeab585fd8', 'CTA-40115011-23', 'f7a06c61-f7f6-404b-8b2a-f45538f482cb', 1500.00, 1500.00, 1500.00, 'vigente', CURRENT_DATE, 43.92, 6);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40115011-23', 1, '2026-07-18', 277.64, 231.43, 46.21, 1268.57, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40115011-23', 2, '2026-08-18', 277.64, 238.56, 39.08, 1030.02, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40115011-23', 3, '2026-09-18', 277.64, 245.91, 31.73, 784.11, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40115011-23', 4, '2026-10-18', 277.64, 253.48, 24.15, 530.63, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40115011-23', 5, '2026-11-18', 277.64, 261.29, 16.35, 269.34, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-40115011-23', 6, '2026-12-18', 277.64, 269.34, 8.3, 0, 'pendiente');

-- ================= CASO 24 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('e0df877f-4084-4adb-9f9f-1d9d06709ed3', '41336036', 'Lisistrata', 'Ramos', '964110224', 'Comercio', 'Variedades Lisistrata', 52, 4100.00, -12.0633, -75.2071, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'e0df877f-4084-4adb-9f9f-1d9d06709ed3', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0633, -75.2071);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('678eef5f-198c-41f1-b502-34be337dd369', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'e0df877f-4084-4adb-9f9f-1d9d06709ed3', 3500.00, 12, 43.92, 'sin garantia', 'Capital de trabajo', 'desembolsado', 3500.00, 'Comercio', 'Variedades Lisistrata', 52, 4100.00, 1700.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('39c542b8-d3b0-4fdf-8a35-8dc44b1343a2', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'e0df877f-4084-4adb-9f9f-1d9d06709ed3', '678eef5f-198c-41f1-b502-34be337dd369', '41336036', 'NORMAL', 1, 6000.00, 0, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('c4bb1f10-fcf3-4b2c-a090-e1e13f8cef9e', 'CTA-41336036-24', 'e0df877f-4084-4adb-9f9f-1d9d06709ed3', 3500.00, 3500.00, 3500.00, 'vigente', CURRENT_DATE, 43.92, 12);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 1, '2026-07-18', 353.31, 245.49, 107.82, 3254.51, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 2, '2026-08-18', 353.31, 253.05, 100.26, 3001.46, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 3, '2026-09-18', 353.31, 260.85, 92.46, 2740.61, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 4, '2026-10-18', 353.31, 268.88, 84.43, 2471.72, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 5, '2026-11-18', 353.31, 277.17, 76.14, 2194.56, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 6, '2026-12-18', 353.31, 285.71, 67.6, 1908.85, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 7, '2027-01-18', 353.31, 294.51, 58.8, 1614.34, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 8, '2027-02-18', 353.31, 303.58, 49.73, 1310.76, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 9, '2027-03-18', 353.31, 312.93, 40.38, 997.83, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 10, '2027-04-18', 353.31, 322.57, 30.74, 675.26, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 11, '2027-05-18', 353.31, 332.51, 20.8, 342.75, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41336036-24', 12, '2027-06-18', 353.31, 342.75, 10.56, 0, 'pendiente');

-- ================= CASO 25 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('25a5b7fa-f874-4687-b5a7-5ed3c30aac73', '41552052', 'Filoctetes', 'Cruz', '964110225', 'Restaurante', 'Cevicheria Filoctetes', 18, 3800.00, -12.093, -75.209, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '25a5b7fa-f874-4687-b5a7-5ed3c30aac73', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.093, -75.209);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('0e17bd5c-a5f8-4505-bfc2-645575a91410', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '25a5b7fa-f874-4687-b5a7-5ed3c30aac73', 11000.00, 18, 40.92, 'sin garantia', 'Ampliacion de local nuevo', 'desembolsado', 7000.00, 'Restaurante', 'Cevicheria Filoctetes', 18, 3800.00, 2200.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('a6935a90-1446-4276-9af6-4004d9b39ed0', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '25a5b7fa-f874-4687-b5a7-5ed3c30aac73', '0e17bd5c-a5f8-4505-bfc2-645575a91410', '41552052', 'CPP', 2, 18000.00, 15, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('5beb3a10-3771-48c3-85d7-6a0032ab78f4', 'CTA-41552052-25', '25a5b7fa-f874-4687-b5a7-5ed3c30aac73', 7000.00, 7000.00, 7000.00, 'vigente', CURRENT_DATE, 40.92, 18);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 1, '2026-07-18', 504.66, 301.67, 202.98, 6698.33, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 2, '2026-08-18', 504.66, 310.42, 194.24, 6387.9, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 3, '2026-09-18', 504.66, 319.42, 185.23, 6068.48, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 4, '2026-10-18', 504.66, 328.69, 175.97, 5739.8, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 5, '2026-11-18', 504.66, 338.22, 166.44, 5401.58, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 6, '2026-12-18', 504.66, 348.02, 156.63, 5053.55, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 7, '2027-01-18', 504.66, 358.12, 146.54, 4695.44, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 8, '2027-02-18', 504.66, 368.5, 136.16, 4326.94, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 9, '2027-03-18', 504.66, 379.19, 125.47, 3947.75, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 10, '2027-04-18', 504.66, 390.18, 114.48, 3557.57, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 11, '2027-05-18', 504.66, 401.5, 103.16, 3156.07, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 12, '2027-06-18', 504.66, 413.14, 91.52, 2742.93, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 13, '2027-07-18', 504.66, 425.12, 79.54, 2317.81, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 14, '2027-08-18', 504.66, 437.45, 67.21, 1880.37, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 15, '2027-09-18', 504.66, 450.13, 54.53, 1430.24, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 16, '2027-10-18', 504.66, 463.18, 41.47, 967.05, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 17, '2027-11-18', 504.66, 476.62, 28.04, 490.44, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41552052-25', 18, '2027-12-18', 504.66, 490.44, 14.22, 0, 'pendiente');

-- ================= CASO 26 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('7fc86a19-8beb-44b8-b220-dfac3a668ab6', '41888088', 'Calirroe', 'Mendoza', '964110226', 'Calzado', 'Calzados Calirroe', 34, 5000.00, -12.0588, -75.2129, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '7fc86a19-8beb-44b8-b220-dfac3a668ab6', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0588, -75.2129);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('6aaf93ab-097a-42c1-a041-2230e887c1c6', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '7fc86a19-8beb-44b8-b220-dfac3a668ab6', 16000.0, 24, 43.92, 'hipotecaria', 'Maquinaria de mayor capacidad', 'desembolsado', 10000.00, 'Calzado', 'Calzados Calirroe', 34, 5000.00, 2600.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('3fc9557c-0e4f-4262-9457-8dbf270e43a7', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '7fc86a19-8beb-44b8-b220-dfac3a668ab6', '6aaf93ab-097a-42c1-a041-2230e887c1c6', '41888088', 'CPP', 1, 9000.00, 20, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('4bd89318-3e96-4693-9fcf-08a2a81a1589', 'CTA-41888088-26', '7fc86a19-8beb-44b8-b220-dfac3a668ab6', 10000.00, 10000.00, 10000.00, 'vigente', CURRENT_DATE, 43.92, 24);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 1, '2026-07-18', 595.61, 287.55, 308.06, 9712.45, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 2, '2026-08-18', 595.61, 296.41, 299.2, 9416.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 3, '2026-09-18', 595.61, 305.54, 290.07, 9110.49, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 4, '2026-10-18', 595.61, 314.96, 280.65, 8795.53, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 5, '2026-11-18', 595.61, 324.66, 270.95, 8470.88, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 6, '2026-12-18', 595.61, 334.66, 260.95, 8136.22, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 7, '2027-01-18', 595.61, 344.97, 250.64, 7791.25, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 8, '2027-02-18', 595.61, 355.6, 240.01, 7435.65, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 9, '2027-03-18', 595.61, 366.55, 229.06, 7069.1, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 10, '2027-04-18', 595.61, 377.84, 217.77, 6691.26, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 11, '2027-05-18', 595.61, 389.48, 206.13, 6301.78, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 12, '2027-06-18', 595.61, 401.48, 194.13, 5900.3, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 13, '2027-07-18', 595.61, 413.85, 181.76, 5486.45, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 14, '2027-08-18', 595.61, 426.6, 169.01, 5059.85, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 15, '2027-09-18', 595.61, 439.74, 155.87, 4620.11, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 16, '2027-10-18', 595.61, 453.28, 142.33, 4166.83, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 17, '2027-11-18', 595.61, 467.25, 128.36, 3699.58, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 18, '2027-12-18', 595.61, 481.64, 113.97, 3217.94, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 19, '2028-01-18', 595.61, 496.48, 99.13, 2721.46, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 20, '2028-02-18', 595.61, 511.77, 83.84, 2209.68, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 21, '2028-03-18', 595.61, 527.54, 68.07, 1682.14, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 22, '2028-04-18', 595.61, 543.79, 51.82, 1138.35, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 23, '2028-05-18', 595.61, 560.54, 35.07, 577.81, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-41888088-26', 24, '2028-06-18', 595.61, 577.81, 17.8, 0, 'pendiente');

-- ================= CASO 27 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('e64686ab-5a22-43f8-83c3-db14ccdb84b6', '42220022', 'Tucidides', 'Quispe', '964110227', 'Ferreteria', 'Ferreteria Tucidides', 40, 6200.00, -11.9176, -75.3155, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'e64686ab-5a22-43f8-83c3-db14ccdb84b6', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -11.9176, -75.3155);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('12cb842b-58ca-4322-9e1e-730107c88a3a', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'e64686ab-5a22-43f8-83c3-db14ccdb84b6', 20000.00, 24, 40.92, 'hipotecaria', 'Compra de stock y montacarga', 'desembolsado', 14000.00, 'Ferreteria', 'Ferreteria Tucidides', 40, 6200.00, 2900.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('2f553ad6-cc94-4dce-a3d2-9aff6ba04d48', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'e64686ab-5a22-43f8-83c3-db14ccdb84b6', '12cb842b-58ca-4322-9e1e-730107c88a3a', '42220022', 'CPP', 2, 18000.00, 15, false);
INSERT INTO cr_creditos (id, cod_cuenta_credito, cliente_id, monto_desembolsado, saldo_capital, saldo_total, estado, fecha_desembolso, tea, cuotas_total)
VALUES ('322c6e58-cbed-464c-bcce-49f00f9764c3', 'CTA-42220022-27', 'e64686ab-5a22-43f8-83c3-db14ccdb84b6', 14000.00, 14000.00, 14000.00, 'vigente', CURRENT_DATE, 40.92, 24);
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 1, '2026-07-18', 817.76, 411.8, 405.97, 13588.2, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 2, '2026-08-18', 817.76, 423.74, 394.03, 13164.47, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 3, '2026-09-18', 817.76, 436.02, 381.74, 12728.44, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 4, '2026-10-18', 817.76, 448.67, 369.09, 12279.77, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 5, '2026-11-18', 817.76, 461.68, 356.08, 11818.09, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 6, '2026-12-18', 817.76, 475.07, 342.7, 11343.03, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 7, '2027-01-18', 817.76, 488.84, 328.92, 10854.19, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 8, '2027-02-18', 817.76, 503.02, 314.75, 10351.17, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 9, '2027-03-18', 817.76, 517.6, 300.16, 9833.56, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 10, '2027-04-18', 817.76, 532.61, 285.15, 9300.95, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 11, '2027-05-18', 817.76, 548.06, 269.71, 8752.89, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 12, '2027-06-18', 817.76, 563.95, 253.81, 8188.94, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 13, '2027-07-18', 817.76, 580.3, 237.46, 7608.64, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 14, '2027-08-18', 817.76, 597.13, 220.63, 7011.51, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 15, '2027-09-18', 817.76, 614.45, 203.32, 6397.06, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 16, '2027-10-18', 817.76, 632.26, 185.5, 5764.8, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 17, '2027-11-18', 817.76, 650.6, 167.17, 5114.2, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 18, '2027-12-18', 817.76, 669.46, 148.3, 4444.74, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 19, '2028-01-18', 817.76, 688.88, 128.89, 3755.86, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 20, '2028-02-18', 817.76, 708.85, 108.91, 3047.01, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 21, '2028-03-18', 817.76, 729.41, 88.36, 2317.6, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 22, '2028-04-18', 817.76, 750.56, 67.2, 1567.04, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 23, '2028-05-18', 817.76, 772.32, 45.44, 794.72, 'pendiente');
INSERT INTO cr_cronograma_pagos (cod_cuenta_credito, nro_cuota, fecha_vencimiento, monto_cuota, monto_capital, monto_interes, saldo, estado_cuota)
VALUES ('CTA-42220022-27', 24, '2028-06-18', 817.76, 794.72, 23.04, 0, 'pendiente');

-- ================= CASO 28 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('2982791a-c247-4385-8e20-095f628ebcc5', '43337037', 'Aquiles', 'Mamani', '964110228', 'Comercio', 'Comercial Aquiles', 60, 9000.00, -12.0657, -75.2099, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '2982791a-c247-4385-8e20-095f628ebcc5', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -12.0657, -75.2099);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('879c84eb-800a-4013-b914-87544254d8d1', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '2982791a-c247-4385-8e20-095f628ebcc5', 15000.00, 24, 43.92, 'hipotecaria', 'Capital de trabajo', 'rechazado', NULL, 'Comercio', 'Comercial Aquiles', 60, 9000.00, 3600.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('138d1a79-704e-4a64-9892-7a745894f7af', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), '2982791a-c247-4385-8e20-095f628ebcc5', '879c84eb-800a-4013-b914-87544254d8d1', '43337037', 'PERDIDA', 4, 40000.00, 210, true);

-- ================= CASO 29 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('d2db4880-c671-4a8e-aff5-24a493709f08', '41884084', 'Medea', 'Apaza', '964110229', 'Bodega', 'Bodega Medea', 22, 1800.00, -12.0489, -75.247, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'd2db4880-c671-4a8e-aff5-24a493709f08', CURRENT_DATE, 'NUEVA_SOLICITUD', 'media', 'visitado', -12.0489, -75.247);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('a8e564e6-187e-4b61-bb66-37a1961aaec6', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'd2db4880-c671-4a8e-aff5-24a493709f08', 14000.00, 18, 43.92, 'sin garantia', 'Compra de camioneta para reparto', 'rechazado', NULL, 'Bodega', 'Bodega Medea', 22, 1800.00, 1100.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('5ffb9ce5-b070-423b-ab83-2780523a8b97', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'd2db4880-c671-4a8e-aff5-24a493709f08', 'a8e564e6-187e-4b61-bb66-37a1961aaec6', '41884084', 'DUDOSO', 3, 25000.00, 95, false);

-- ================= CASO 30 ================= 
INSERT INTO clientes (id, numero_documento, nombres, apellidos, telefono, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, lat, lng, es_prospecto)
VALUES ('c70b70cc-1753-4fd0-b93c-b352b338ec21', '43334034', 'Esquines', 'Rojas', '964110230', 'Transporte', 'Fletes Esquines', 30, 7000.00, -11.774, -75.501, true);
INSERT INTO cartera_diaria (asesor_id, cliente_id, fecha_asignacion, tipo_gestion, prioridad, estado_visita, lat_visita, lng_visita)
VALUES ((SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'c70b70cc-1753-4fd0-b93c-b352b338ec21', CURRENT_DATE, 'NUEVA_SOLICITUD', 'alta', 'visitado', -11.774, -75.501);
INSERT INTO solicitudes_credito (id, asesor_id, cliente_id, monto_solicitado, plazo_meses, tea_referencial, garantia, destino_credito, estado, monto_aprobado, tipo_negocio, nombre_negocio, antiguedad_negocio_meses, ingresos_estimados, gastos_mensuales)
VALUES ('60f9a630-8bab-440e-ac40-0b0a6298e8eb', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'c70b70cc-1753-4fd0-b93c-b352b338ec21', 30000.00, 24, 43.92, 'vehicular', 'Compra de unidad de transporte', 'rechazado', NULL, 'Transporte', 'Fletes Esquines', 30, 7000.00, 3200.00);
INSERT INTO consultas_buro (id, asesor_id, cliente_id, solicitud_id, dni_consultado, calificacion_sbs, entidades_con_deuda, deuda_total_pen, dias_mayor_mora, en_lista_negra)
VALUES ('908e52b5-e4fd-4250-a2c1-c9fbd3036ba5', (SELECT id FROM asesores WHERE codigo_empleado = '0001' LIMIT 1), 'c70b70cc-1753-4fd0-b93c-b352b338ec21', '60f9a630-8bab-440e-ac40-0b0a6298e8eb', '43334034', 'DUDOSO', 3, 25000.00, 95, true);

COMMIT;
