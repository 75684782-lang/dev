import '../model/solicitud.dart';
import '../services/api_client.dart';

class SolicitudRepository {
  Future<List<Solicitud>> listarMisSolicitudes() async {
    final result = await ApiClient.get('/solicitudes/mias');
    final data = result['data'] as List<dynamic>;
    return data
        .map((e) => Solicitud.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> crearSolicitud(Map<String, dynamic> body) async {
    final result = await ApiClient.post('/solicitudes/solicitar', body);
    return {'numero_expediente': result['numero_expediente']};
  }

  Future<Map<String, dynamic>> obtenerSolicitud(String expediente) async {
    final data = await ApiClient.get('/solicitudes/$expediente');
    final lineaTiempo = [
      {'estado': 'enviado', 'label': 'Recibido', 'orden': 0},
      {'estado': 'en_evaluacion', 'label': 'En Evaluación', 'orden': 1},
      {'estado': 'aprobado', 'label': 'Aprobado', 'orden': 2},
      {'estado': 'desembolsado', 'label': 'Desembolsado', 'orden': 3},
    ];

    final estadoActual = data['estado'] as String? ?? '';
    final ordenActual = (lineaTiempo.firstWhere(
      (lt) => lt['estado'] == estadoActual,
      orElse: () => {'orden': 0},
    )['orden'] as int);

    return {
      'numero_expediente': data['numero_expediente'],
      'cliente': data['cliente'] ?? data['clientes_ficha']?['nombre_completo'] ?? '',
      'monto_solicitado': data['monto_solicitado'],
      'plazo_meses': data['plazo_meses'],
      'tea': data['tea'],
      'estado': estadoActual,
      'linea_tiempo': (data['linea_tiempo'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList()
          ?? lineaTiempo.map((e) => {
        ...e,
        'activo': (e['orden'] as int) <= ordenActual,
      }).toList(),
    };
  }

  Future<List<Map<String, dynamic>>> obtenerCronograma(String expediente) async {
    final data = await ApiClient.get('/cronograma/$expediente');
    final list = data['cronograma'] as List<dynamic>? ?? [];
    return list.map((r) => {
      'cuota': r['numero_cuota'],
      'fecha': r['fecha_pago'],
      'monto': (r['monto_cuota'] as num).toDouble(),
      'capital': (r['capital'] as num).toDouble(),
      'interes': (r['interes'] as num).toDouble(),
      'saldo': (r['saldo_pendiente'] as num).toDouble(),
    }).toList();
  }
}
