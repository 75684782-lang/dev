class SolicitudInfo {
  final String numeroExpediente;
  final double montoSolicitado;
  final String estado;
  final int plazoMeses;
  final String garantia;
  final String destinoCredito;
  final bool conDesgravamen;

  SolicitudInfo({
    required this.numeroExpediente,
    required this.montoSolicitado,
    required this.estado,
    required this.plazoMeses,
    required this.garantia,
    required this.destinoCredito,
    required this.conDesgravamen,
  });

  factory SolicitudInfo.fromJson(Map<String, dynamic> json) {
    return SolicitudInfo(
      numeroExpediente: json['numero_expediente'] ?? '',
      montoSolicitado: (json['monto_solicitado'] ?? 0).toDouble(),
      estado: json['estado'] ?? '',
      plazoMeses: json['plazo_meses'] ?? 1,
      garantia: json['garantia'] ?? '',
      destinoCredito: json['destino_credito'] ?? '',
      conDesgravamen: json['con_desgravamen'] ?? true,
    );
  }
}

class ClienteCartera {
  final String id;
  final String nombreCompleto;
  final String telefono;
  final String negocio;
  final String tipoGestion;
  final String prioridad;
  bool visitado;
  final SolicitudInfo? solicitud;
  final String? clienteFichaId;
  final double? ingresosEstimados;
  final double? gastosEstimados;

  ClienteCartera({
    required this.id,
    required this.nombreCompleto,
    required this.telefono,
    required this.negocio,
    required this.tipoGestion,
    required this.prioridad,
    required this.visitado,
    this.solicitud,
    this.clienteFichaId,
    this.ingresosEstimados,
    this.gastosEstimados,
  });

  String get nombre => nombreCompleto;

  factory ClienteCartera.fromJson(Map<String, dynamic> json) {
    SolicitudInfo? sol;
    if (json['solicitud'] != null) {
      sol = SolicitudInfo.fromJson(json['solicitud']);
    }
    final ficha = json['clientes_ficha'] as Map<String, dynamic>?;
    return ClienteCartera(
      id: json['id'] ?? '',
      nombreCompleto: json['nombre'] ?? json['cliente'] ?? json['nombre_completo'] ?? '',
      telefono: json['telefono'] ?? '',
      negocio: json['negocio'] ?? '',
      tipoGestion: json['tipo_gestion'] ?? '',
      prioridad: json['prioridad'] ?? 'normal',
      visitado: json['visitado'] ?? false,
      solicitud: sol,
      clienteFichaId: ficha?['id'] ?? json['cliente_ficha_id'],
      ingresosEstimados: (json['ingresos_estimados'] as num?)?.toDouble(),
      gastosEstimados: (json['gastos_estimados'] as num?)?.toDouble(),
    );
  }
}
