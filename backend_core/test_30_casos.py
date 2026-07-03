"""
Test riguroso de los 30 Casos Prácticos de Crédito Empresarial - CRAC Incasur
Valida: buró, simulación, capacidad de pago, cronograma de amortización y simulador educativo.
"""
import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.services.financiero import (
    _calcular_cronograma, calcular_cronograma, validar_capacidad_pago
)
from app.routers.buro import SBS_MAP
from app.models.schemas import SimularRequest

client = TestClient(app)

# ──────────────────────────────────────────────
# DATOS DE LOS 30 CASOS
# ──────────────────────────────────────────────
# Cada caso: (nombre, dni, monto, plazo, con_seguro, tea_esperada,
#             cuota_esperada, burro_calif, burro_ent, burro_deuda, burro_mora, burro_inhab,
#             ingresos, costos, gastos, excedente_esp, cobertura_esp, capacidad_apto,
#             decision_comite, [si condicionado: monto_final, cuota_final],
#             [cronograma: [(cuota1_cap, cuota1_int, cuota1_saldo), ...]])

CASOS = [
    # Caso 1: Anaximandro Quispe - APROBADO
    {
        "id": 1, "nombre": "Anaximandro Quispe", "dni": "40118120",
        "monto": 1000, "plazo": 12, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 100.95,
        "buro_calif": "NORMAL", "buro_ent": 1, "buro_deuda": 4500, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 2200, "costos": 0, "gastos": 900,
        "excedente_esp": 1300.00, "cobertura_esp": 1287.8, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (70.14, 30.81, 929.86),
            (72.31, 28.64, 857.55),
            (74.53, 26.42, 783.02),
        ]
    },
    # Caso 2: Eulalia Mamani - APROBADO
    {
        "id": 2, "nombre": "Eulalia Mamani", "dni": "41223341",
        "monto": 3000, "plazo": 12, "con_seguro": True,
        "tea_esperada": 40.92, "cuota_esperada": 299.59,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 12000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 3000, "costos": 0, "gastos": 1400,
        "excedente_esp": 1600.00, "cobertura_esp": 534.1, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (212.60, 86.99, 2787.40),
            (218.76, 80.83, 2568.64),
            (225.11, 74.48, 2343.53),
        ]
    },
    # Caso 3: Teofilo Huaman - APROBADO
    {
        "id": 3, "nombre": "Teofilo Huaman", "dni": "42330336",
        "monto": 5000, "plazo": 18, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 366.02,
        "buro_calif": "NORMAL", "buro_ent": 1, "buro_deuda": 6000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 4200, "costos": 0, "gastos": 1800,
        "excedente_esp": 2400.00, "cobertura_esp": 655.7, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (211.99, 154.03, 4788.01),
            (218.52, 147.50, 4569.49),
            (225.25, 140.77, 4344.24),
        ]
    },
    # Caso 4: Casandra Flores - APROBADO
    {
        "id": 4, "nombre": "Casandra Flores", "dni": "43440349",
        "monto": 8000, "plazo": 6, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1480.73,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 14000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 7000, "costos": 0, "gastos": 2600,
        "excedente_esp": 4400.00, "cobertura_esp": 297.2, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (1234.29, 246.44, 6765.71),
            (1272.31, 208.42, 5493.40),
            (1311.50, 169.23, 4181.90),
        ]
    },
    # Caso 5: Demostenes Rojas - APROBADO
    {
        "id": 5, "nombre": "Demostenes Rojas", "dni": "40556071",
        "monto": 10000, "plazo": 12, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1009.46,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 12000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 5200, "costos": 0, "gastos": 2100,
        "excedente_esp": 3100.00, "cobertura_esp": 307.1, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (701.40, 308.06, 9298.60),
            (723.01, 286.45, 8575.59),
            (745.28, 264.18, 7830.31),
        ]
    },
    # Caso 6: Hipatia Condori - APROBADO
    {
        "id": 6, "nombre": "Hipatia Condori", "dni": "41669066",
        "monto": 12000, "plazo": 24, "con_seguro": True,
        "tea_esperada": 40.92, "cuota_esperada": 700.94,
        "buro_calif": "NORMAL", "buro_ent": 1, "buro_deuda": 6000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 6800, "costos": 0, "gastos": 2900,
        "excedente_esp": 3900.00, "cobertura_esp": 556.4, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (352.97, 347.97, 11647.03),
            (363.20, 337.74, 11283.83),
            (373.74, 327.20, 10910.09),
        ]
    },
    # Caso 7: Anibal Vargas - APROBADO
    {
        "id": 7, "nombre": "Anibal Vargas", "dni": "43773379",
        "monto": 15000, "plazo": 18, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1098.07,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 14000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 9500, "costos": 0, "gastos": 4200,
        "excedente_esp": 5300.00, "cobertura_esp": 482.7, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (635.99, 462.08, 14364.01),
            (655.58, 442.49, 13708.43),
            (675.77, 422.30, 13032.66),
        ]
    },
    # Caso 8: Penelope Apaza - APROBADO
    {
        "id": 8, "nombre": "Penelope Apaza", "dni": "40886086",
        "monto": 18000, "plazo": 24, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1072.10,
        "buro_calif": "NORMAL", "buro_ent": 1, "buro_deuda": 6000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 8800, "costos": 0, "gastos": 3600,
        "excedente_esp": 5200.00, "cobertura_esp": 485.0, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (517.60, 554.50, 17482.40),
            (533.54, 538.56, 16948.86),
            (549.98, 522.12, 16398.88),
        ]
    },
    # Caso 9: Heraclito Ccahua - APROBADO
    {
        "id": 9, "nombre": "Heraclito Ccahua", "dni": "41990091",
        "monto": 20000, "plazo": 36, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 927.12,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 12000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 12000, "costos": 0, "gastos": 5000,
        "excedente_esp": 7000.00, "cobertura_esp": 755.1, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (311.01, 616.11, 19688.99),
            (320.59, 606.53, 19368.40),
            (330.47, 596.65, 19037.93),
        ]
    },
    # Caso 10: Cleopatra Soto - APROBADO
    {
        "id": 10, "nombre": "Cleopatra Soto", "dni": "43003039",
        "monto": 25000, "plazo": 24, "con_seguro": True,
        "tea_esperada": 40.92, "cuota_esperada": 1460.29,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 14000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 11000, "costos": 0, "gastos": 4400,
        "excedente_esp": 6600.00, "cobertura_esp": 452.0, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (735.35, 724.94, 24264.65),
            (756.67, 703.62, 23507.98),
            (778.61, 681.68, 22729.37),
        ]
    },
    # Caso 11: Esquilo Ramos - APROBADO
    {
        "id": 11, "nombre": "Esquilo Ramos", "dni": "40110010",
        "monto": 2000, "plazo": 12, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 201.89,
        "buro_calif": "NORMAL", "buro_ent": 1, "buro_deuda": 4500, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 1900, "costos": 0, "gastos": 800,
        "excedente_esp": 1100.00, "cobertura_esp": 544.9, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (140.28, 61.61, 1859.72),
            (144.60, 57.29, 1715.12),
            (149.05, 52.84, 1566.07),
        ]
    },
    # Caso 12: Ariadna Quispe - APROBADO
    {
        "id": 12, "nombre": "Ariadna Quispe", "dni": "41226021",
        "monto": 4000, "plazo": 18, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 292.82,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 12000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 3300, "costos": 0, "gastos": 1300,
        "excedente_esp": 2000.00, "cobertura_esp": 683.0, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (169.60, 123.22, 3830.40),
            (174.82, 118.00, 3655.58),
            (180.21, 112.61, 3475.37),
        ]
    },
    # Caso 13: Sofocles Huanca - APROBADO
    {
        "id": 13, "nombre": "Sofocles Huanca", "dni": "43336033",
        "monto": 6000, "plazo": 12, "con_seguro": True,
        "tea_esperada": 40.92, "cuota_esperada": 599.17,
        "buro_calif": "NORMAL", "buro_ent": 0, "buro_deuda": 0, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 5600, "costos": 0, "gastos": 2300,
        "excedente_esp": 3300.00, "cobertura_esp": 550.8, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (425.18, 173.99, 5574.82),
            (437.51, 161.66, 5137.31),
            (450.20, 148.97, 4687.11),
        ]
    },
    # Caso 14: Casiopea Torres - APROBADO
    {
        "id": 14, "nombre": "Casiopea Torres", "dni": "40550055",
        "monto": 7500, "plazo": 6, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1388.18,
        "buro_calif": "DEFICIENTE", "buro_ent": 2, "buro_deuda": 16000, "buro_mora": 45, "buro_inhab": False,
        "ingresos": 7400, "costos": 0, "gastos": 3000,
        "excedente_esp": 4400.00, "cobertura_esp": 317.0, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (1157.14, 231.04, 6342.86),
            (1192.78, 195.40, 5150.08),
            (1229.53, 158.65, 3920.55),
        ]
    },
    # Caso 15: Aristofanes Cruz - APROBADO
    {
        "id": 15, "nombre": "Aristofanes Cruz", "dni": "41669166",
        "monto": 9000, "plazo": 24, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 536.05,
        "buro_calif": "NORMAL", "buro_ent": 1, "buro_deuda": 6000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 8200, "costos": 0, "gastos": 3300,
        "excedente_esp": 4900.00, "cobertura_esp": 914.1, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (258.80, 277.25, 8741.20),
            (266.77, 269.28, 8474.43),
            (274.99, 261.06, 8199.44),
        ]
    },
    # Caso 16: Calipso Mendoza - APROBADO
    {
        "id": 16, "nombre": "Calipso Mendoza", "dni": "43880088",
        "monto": 11000, "plazo": 18, "con_seguro": True,
        "tea_esperada": 40.92, "cuota_esperada": 793.03,
        "buro_calif": "CPP", "buro_ent": 1, "buro_deuda": 9000, "buro_mora": 20, "buro_inhab": False,
        "ingresos": 7900, "costos": 0, "gastos": 3100,
        "excedente_esp": 4800.00, "cobertura_esp": 605.3, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (474.06, 318.97, 10525.94),
            (487.80, 305.23, 10038.14),
            (501.95, 291.08, 9536.19),
        ]
    },
    # Caso 17: Demetrio Quispe - APROBADO
    {
        "id": 17, "nombre": "Demetrio Quispe", "dni": "40119019",
        "monto": 13500, "plazo": 12, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1362.77,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 14000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 11500, "costos": 0, "gastos": 4700,
        "excedente_esp": 6800.00, "cobertura_esp": 499.0, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (946.89, 415.88, 12553.11),
            (976.06, 386.71, 11577.05),
            (1006.13, 356.64, 10570.92),
        ]
    },
    # Caso 18: Antigona Flores - APROBADO
    {
        "id": 18, "nombre": "Antigona Flores", "dni": "41226126",
        "monto": 16000, "plazo": 36, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 741.70,
        "buro_calif": "NORMAL", "buro_ent": 1, "buro_deuda": 6000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 9200, "costos": 0, "gastos": 3900,
        "excedente_esp": 5300.00, "cobertura_esp": 714.6, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (248.81, 492.89, 15751.19),
            (256.48, 485.22, 15494.71),
            (264.38, 477.32, 15230.33),
        ]
    },
    # Caso 19: Pitagoras Rojas - APROBADO
    {
        "id": 19, "nombre": "Pitagoras Rojas", "dni": "43339033",
        "monto": 17000, "plazo": 24, "con_seguro": True,
        "tea_esperada": 40.92, "cuota_esperada": 993.00,
        "buro_calif": "NORMAL", "buro_ent": 0, "buro_deuda": 0, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 13000, "costos": 0, "gastos": 5200,
        "excedente_esp": 7800.00, "cobertura_esp": 785.5, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (500.04, 492.96, 16499.96),
            (514.54, 478.46, 15985.42),
            (529.46, 463.54, 15455.96),
        ]
    },
    # Caso 20: Berenice Apaza - APROBADO
    {
        "id": 20, "nombre": "Berenice Apaza", "dni": "40556056",
        "monto": 19000, "plazo": 18, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1390.89,
        "buro_calif": "NORMAL", "buro_ent": 1, "buro_deuda": 6000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 8600, "costos": 0, "gastos": 3500,
        "excedente_esp": 5100.00, "cobertura_esp": 366.7, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (805.58, 585.31, 18194.42),
            (830.40, 560.49, 17364.02),
            (855.98, 534.91, 16508.04),
        ]
    },
    # Caso 21: Anaxagoras Huaman - APROBADO
    {
        "id": 21, "nombre": "Anaxagoras Huaman", "dni": "43889089",
        "monto": 22000, "plazo": 36, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1019.83,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 14000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 14000, "costos": 0, "gastos": 5800,
        "excedente_esp": 8200.00, "cobertura_esp": 804.1, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (342.11, 677.72, 21657.89),
            (352.65, 667.18, 21305.24),
            (363.51, 656.32, 20941.73),
        ]
    },
    # Caso 22: Climene Vargas - APROBADO
    {
        "id": 22, "nombre": "Climene Vargas", "dni": "41003001",
        "monto": 24000, "plazo": 24, "con_seguro": True,
        "tea_esperada": 40.92, "cuota_esperada": 1401.88,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 12000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 13500, "costos": 0, "gastos": 5500,
        "excedente_esp": 8000.00, "cobertura_esp": 570.7, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (705.94, 695.94, 23294.06),
            (726.41, 675.47, 22567.65),
            (747.47, 654.41, 21820.18),
        ]
    },
    # Caso 23: Epaminondas Soto - APROBADO
    {
        "id": 23, "nombre": "Epaminondas Soto", "dni": "40115011",
        "monto": 1500, "plazo": 6, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 277.64,
        "buro_calif": "NORMAL", "buro_ent": 2, "buro_deuda": 12000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 2600, "costos": 0, "gastos": 1000,
        "excedente_esp": 1600.00, "cobertura_esp": 576.3, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (231.43, 46.21, 1268.57),
            (238.56, 39.08, 1030.01),
            (245.91, 31.73, 784.10),
        ]
    },
    # Caso 24: Lisistrata Ramos - APROBADO
    {
        "id": 24, "nombre": "Lisistrata Ramos", "dni": "41336036",
        "monto": 3500, "plazo": 12, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 353.31,
        "buro_calif": "NORMAL", "buro_ent": 1, "buro_deuda": 6000, "buro_mora": 0, "buro_inhab": False,
        "ingresos": 4100, "costos": 0, "gastos": 1700,
        "excedente_esp": 2400.00, "cobertura_esp": 679.3, "capacidad_apto": True,
        "decision": "APROBADO",
        "cronograma": [
            (245.49, 107.82, 3254.51),
            (253.05, 100.26, 3001.46),
            (260.85, 92.46, 2740.61),
        ]
    },
    # Caso 25: Filoctetes Cruz - CONDICIONADO
    {
        "id": 25, "nombre": "Filoctetes Cruz", "dni": "41552052",
        "monto": 11000, "plazo": 18, "con_seguro": True,
        "tea_esperada": 40.92, "cuota_esperada": 793.03,
        "buro_calif": "CPP", "buro_ent": 2, "buro_deuda": 18000, "buro_mora": 15, "buro_inhab": False,
        "ingresos": 3800, "costos": 0, "gastos": 2200,
        "excedente_esp": 1600.00, "cobertura_esp": None, "capacidad_apto": True,
        "decision": "CONDICIONADO",
        "monto_final": 7000, "cuota_final": 504.66,
        "cronograma": [
            (301.68, 202.98, 6698.32),
            (310.42, 194.24, 6387.90),
            (319.43, 185.23, 6068.47),
        ]
    },
    # Caso 26: Calirroe Mendoza - CONDICIONADO
    {
        "id": 26, "nombre": "Calirroe Mendoza", "dni": "41888088",
        "monto": 16000, "plazo": 24, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 952.98,
        "buro_calif": "CPP", "buro_ent": 1, "buro_deuda": 9000, "buro_mora": 20, "buro_inhab": False,
        "ingresos": 5000, "costos": 0, "gastos": 2600,
        "excedente_esp": 2400.00, "cobertura_esp": None, "capacidad_apto": True,
        "decision": "CONDICIONADO",
        "monto_final": 10000, "cuota_final": 595.61,
        "cronograma": [
            (287.55, 308.06, 9712.45),
            (296.41, 299.20, 9416.04),
            (305.54, 290.07, 9110.50),
        ]
    },
    # Caso 27: Tucidides Quispe - CONDICIONADO
    {
        "id": 27, "nombre": "Tucidides Quispe", "dni": "42220022",
        "monto": 20000, "plazo": 24, "con_seguro": True,
        "tea_esperada": 40.92, "cuota_esperada": 1168.23,
        "buro_calif": "CPP", "buro_ent": 2, "buro_deuda": 18000, "buro_mora": 15, "buro_inhab": False,
        "ingresos": 6200, "costos": 0, "gastos": 2900,
        "excedente_esp": 3300.00, "cobertura_esp": None, "capacidad_apto": True,
        "decision": "CONDICIONADO",
        "monto_final": 14000, "cuota_final": 817.76,
        "cronograma": [
            (411.79, 405.97, 13588.21),
            (423.73, 394.03, 13164.48),
            (436.02, 381.74, 12728.46),
        ]
    },
    # Caso 28: Aquiles Mamani - RECHAZADO (inhabilitado)
    {
        "id": 28, "nombre": "Aquiles Mamani", "dni": "43337037",
        "monto": 15000, "plazo": 24, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": None,
        "buro_calif": "PERDIDA", "buro_ent": 4, "buro_deuda": 40000, "buro_mora": 210, "buro_inhab": True,
        "ingresos": 9000, "costos": 0, "gastos": 3600,
        "excedente_esp": 5400.00, "cobertura_esp": None, "capacidad_apto": None,
        "decision": "RECHAZADO",
    },
    # Caso 29: Medea Apaza - RECHAZADO (capacidad insuficiente)
    {
        "id": 29, "nombre": "Medea Apaza", "dni": "41884084",
        "monto": 14000, "plazo": 18, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1024.87,
        "buro_calif": "DUDOSO", "buro_ent": 3, "buro_deuda": 25000, "buro_mora": 95, "buro_inhab": False,
        "ingresos": 1800, "costos": 0, "gastos": 1100,
        "excedente_esp": 700.00, "cobertura_esp": 68.3, "capacidad_apto": False,
        "decision": "RECHAZADO",
    },
    # Caso 30: Esquines Rojas - RECHAZADO (DUDOSO)
    {
        "id": 30, "nombre": "Esquines Rojas", "dni": "43334034",
        "monto": 30000, "plazo": 24, "con_seguro": False,
        "tea_esperada": 43.92, "cuota_esperada": 1786.83,
        "buro_calif": "DUDOSO", "buro_ent": 3, "buro_deuda": 25000, "buro_mora": 95, "buro_inhab": False,
        "ingresos": 7000, "costos": 0, "gastos": 3200,
        "excedente_esp": 3800.00, "cobertura_esp": None, "capacidad_apto": True,
        "decision": "RECHAZADO",
    },
]

# ──────────────────────────────────────────────
# 1. TEST: BURÓ SIMULADO
# ──────────────────────────────────────────────
@pytest.mark.parametrize("caso", CASOS, ids=lambda c: f"Cas{c['id']}-{c['nombre']}")
def test_buro(caso):
    dni = caso["dni"]
    resp = client.get(f"/buro/{dni}")
    assert resp.status_code == 200, f"Buró {dni} failed: {resp.text}"
    data = resp.json()
    assert data["calificacion"] == caso["buro_calif"], (
        f"Cas{caso['id']}: calificacion esperada {caso['buro_calif']}, got {data['calificacion']}"
    )
    assert data["entidades_con_deuda"] == caso["buro_ent"], (
        f"Cas{caso['id']}: entidades esperadas {caso['buro_ent']}, got {data['entidades_con_deuda']}"
    )
    assert data["deuda_total"] == caso["buro_deuda"], (
        f"Cas{caso['id']}: deuda esperada {caso['buro_deuda']}, got {data['deuda_total']}"
    )
    assert data["dias_mayor_mora"] == caso["buro_mora"], (
        f"Cas{caso['id']}: dias_mora esperados {caso['buro_mora']}, got {data['dias_mayor_mora']}"
    )
    assert data["inhabilitado"] == caso["buro_inhab"], (
        f"Cas{caso['id']}: inhabilitado esperado {caso['buro_inhab']}, got {data['inhabilitado']}"
    )
    # Verify the mapping matches SBS_MAP
    ultimo = dni[-1]
    expected = SBS_MAP[ultimo]
    assert data["calificacion"] == expected["calificacion"]
    assert data["entidades_con_deuda"] == expected["entidades"]
    assert data["deuda_total"] == expected["deuda_total"]
    assert data["dias_mayor_mora"] == expected["dias_mora"]
    assert data["inhabilitado"] == expected["inhabilitado"]


# ──────────────────────────────────────────────
# 2. TEST: SIMULACIÓN DE CUOTA (API)
# ──────────────────────────────────────────────
@pytest.mark.parametrize("caso", CASOS, ids=lambda c: f"Cas{c['id']}-{c['nombre']}")
def test_simulacion_cuota(caso):
    """Verifica que la cuota fija calculada por la API coincide con la esperada."""
    if caso["cuota_esperada"] is None:
        pytest.skip(f"Cas{caso['id']}: no tiene cuota esperada (rechazado)")
    resp = client.post("/solicitudes/simular", json={
        "monto": caso["monto"],
        "plazo_meses": caso["plazo"],
        "con_desgravamen": caso["con_seguro"],
    })
    assert resp.status_code == 200, f"Simulación caso {caso['id']} failed: {resp.text}"
    data = resp.json()
    assert data["tea"] == caso["tea_esperada"], (
        f"Cas{caso['id']}: TEA esperada {caso['tea_esperada']}, got {data['tea']}"
    )
    assert abs(data["cuota_fija"] - caso["cuota_esperada"]) < 0.02, (
        f"Cas{caso['id']}: cuota esperada {caso['cuota_esperada']}, got {data['cuota_fija']}"
    )


# ──────────────────────────────────────────────
# 3. TEST: SIMULACIÓN DIRECTA (sin API)
# ──────────────────────────────────────────────
@pytest.mark.parametrize("caso", CASOS, ids=lambda c: f"Cas{c['id']}-{c['nombre']}")
def test_simulacion_directa(caso):
    """Verifica el motor financiero directamente."""
    if caso["cuota_esperada"] is None:
        pytest.skip(f"Cas{caso['id']}: no tiene cuota esperada")
    req = SimularRequest(
        monto=caso["monto"],
        plazo_meses=caso["plazo"],
        con_desgravamen=caso["con_seguro"],
    )
    result = calcular_cronograma(req)
    assert result.tea == caso["tea_esperada"], (
        f"Cas{caso['id']}: TEA esperada {caso['tea_esperada']}, got {result.tea}"
    )
    assert abs(result.cuota_fija - caso["cuota_esperada"]) < 0.02, (
        f"Cas{caso['id']}: cuota esperada {caso['cuota_esperada']}, got {result.cuota_fija}"
    )


# ──────────────────────────────────────────────
# 4. TEST: CRONOGRAMA DE AMORTIZACIÓN
# ──────────────────────────────────────────────
@pytest.mark.parametrize("caso", [c for c in CASOS if c.get("cronograma")],
                         ids=lambda c: f"Cas{c['id']}-{c['nombre']}")
def test_cronograma_amortizacion(caso):
    """
    Verifica que las primeras 3 cuotas del cronograma coincidan exactamente
    con los valores esperados (capital, interés, saldo pendiente).
    """
    monto_final = caso.get("monto_final", caso["monto"])
    plazo_final = caso.get("plazo_final", caso["plazo"])
    # Los casos condicionados usan seguro original
    con_seg = caso["con_seguro"]

    req = SimularRequest(
        monto=monto_final,
        plazo_meses=plazo_final,
        con_desgravamen=con_seg,
    )
    result = calcular_cronograma(req)
    assert len(result.cronograma) == plazo_final, (
        f"Cas{caso['id']}: esperado {plazo_final} cuotas, got {len(result.cronograma)}"
    )

    for i, (esp_cap, esp_int, esp_saldo) in enumerate(caso["cronograma"]):
        cuota = result.cronograma[i]
        tol = 0.03
        errs = []
        if abs(cuota.capital - esp_cap) > tol:
            errs.append(f"capital cuota#{i+1}: esperado {esp_cap}, got {cuota.capital}")
        if abs(cuota.interes - esp_int) > tol:
            errs.append(f"interes cuota#{i+1}: esperado {esp_int}, got {cuota.interes}")
        if abs(cuota.saldo_pendiente - esp_saldo) > tol:
            errs.append(f"saldo cuota#{i+1}: esperado {esp_saldo}, got {cuota.saldo_pendiente}")
        assert not errs, f"Cas{caso['id']}: {'; '.join(errs)}"


# ──────────────────────────────────────────────
# 5. TEST: VALIDACIÓN DE CAPACIDAD DE PAGO
# ──────────────────────────────────────────────
@pytest.mark.parametrize("caso", [c for c in CASOS if c["decision"] != "RECHAZADO"
                                   or c["id"] == 29],
                         ids=lambda c: f"Cas{c['id']}-{c['nombre']}")
def test_capacidad_pago(caso):
    """Verifica que la validación de capacidad de pago sea correcta."""
    if caso["cobertura_esp"] is None and caso["capacidad_apto"] is None:
        pytest.skip(f"Cas{caso['id']}: sin datos de capacidad")
    
    cuota = caso.get("cuota_final", caso["cuota_esperada"])
    if cuota is None:
        pytest.skip(f"Cas{caso['id']}: sin cuota para validar capacidad")
    
    result = validar_capacidad_pago(
        caso["ingresos"], caso["costos"], caso["gastos"], cuota
    )
    assert abs(result["excedente_familiar"] - caso["excedente_esp"]) < 0.02, (
        f"Cas{caso['id']}: excedente esperado {caso['excedente_esp']}, got {result['excedente_familiar']}"
    )
    if caso["cobertura_esp"] is not None:
        assert abs(result["cobertura_porcentaje"] - caso["cobertura_esp"]) < 1.0, (
            f"Cas{caso['id']}: cobertura esperada {caso['cobertura_esp']}, got {result['cobertura_porcentaje']}"
        )
    if caso["capacidad_apto"] is not None:
        assert result["suficiente"] == caso["capacidad_apto"], (
            f"Cas{caso['id']}: capacidad suficiente esperada {caso['capacidad_apto']}, got {result['suficiente']}"
        )


# ──────────────────────────────────────────────
# 6. TEST: SIMULADOR EDUCATIVO
# ──────────────────────────────────────────────
def test_simulador_educativo():
    """Verifica que el simulador educativo funcione correctamente."""
    # Usar caso 1 como referencia
    resp = client.post("/solicitudes/simular/educativo?monto=1000&plazo=12")
    assert resp.status_code == 200
    data = resp.json()
    assert data["tea"] == 43.92
    assert abs(data["cuota_fija"] - 100.95) < 0.02
    assert data["porcentaje_capital"] > 0
    assert data["porcentaje_interes"] > 0
    assert abs(data["porcentaje_capital"] + data["porcentaje_interes"] - 100) < 0.1
    assert len(data["cronograma"]) == 12


# ──────────────────────────────────────────────
# 7. TEST: CASOS CONDICIONADOS - CUOTA RECALCULADA
# ──────────────────────────────────────────────
@pytest.mark.parametrize("caso", [c for c in CASOS if c["decision"] == "CONDICIONADO"],
                         ids=lambda c: f"Cas{c['id']}-{c['nombre']}")
def test_condicionado_cuota(caso):
    """
    Para casos condicionados, verifica que la cuota sobre el monto aprobado
    (reducido) sea correcta.
    """
    # Usar los parámetros ORIGINALES del caso pero con el monto reducido
    req = SimularRequest(
        monto=caso["monto_final"],
        plazo_meses=caso["plazo"],
        con_desgravamen=caso["con_seguro"],
    )
    result = calcular_cronograma(req)
    assert abs(result.cuota_fija - caso["cuota_final"]) < 0.02, (
        f"Cas{caso['id']}: cuota condicionada esperada {caso['cuota_final']}, got {result.cuota_fija}"
    )


# ──────────────────────────────────────────────
# 8. TEST: INTEGRIDAD DE LAS DECISIONES
# ──────────────────────────────────────────────
def test_integridad_decisiones():
    """Verifica el resumen de decisiones: 24 aprobados, 3 condicionados, 3 rechazados."""
    decisions = {}
    for c in CASOS:
        decisions[c["decision"]] = decisions.get(c["decision"], 0) + 1
    assert decisions.get("APROBADO", 0) == 24, f"Esperados 24 APROBADOS, got {decisions.get('APROBADO', 0)}"
    assert decisions.get("CONDICIONADO", 0) == 3, f"Esperados 3 CONDICIONADOS, got {decisions.get('CONDICIONADO', 0)}"
    assert decisions.get("RECHAZADO", 0) == 3, f"Esperados 3 RECHAZADOS, got {decisions.get('RECHAZADO', 0)}"


# ──────────────────────────────────────────────
# 9. TEST: MONTO TOTAL DE APROBADOS VS RECHAZADOS
# ──────────────────────────────────────────────
def test_montos_totales():
    """Verifica que los montos totales tengan sentido."""
    total_aprobado = sum(c["monto"] for c in CASOS if c["decision"] == "APROBADO")
    total_cond = sum(c["monto"] for c in CASOS if c["decision"] == "CONDICIONADO")
    total_rech = sum(c["monto"] for c in CASOS if c["decision"] == "RECHAZADO")
    monto_final_cond = sum(c["monto_final"] for c in CASOS if c["decision"] == "CONDICIONADO")
    
    assert total_aprobado > 0
    assert total_cond > monto_final_cond  # montos reducidos
    assert total_rech > 0


if __name__ == "__main__":
    pytest.main([__file__, "-v", "--tb=short"])
