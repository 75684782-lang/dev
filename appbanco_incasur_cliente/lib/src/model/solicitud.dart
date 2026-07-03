class Solicitud {
  final String id;
  final String numeroExpediente;
  final double montoSolicitado;
  final int plazoMeses;
  final double tea;
  final bool conDesgravamen;
  final String garantia;
  final String destinoCredito;
  final String estado;

  Solicitud({
    required this.id,
    required this.numeroExpediente,
    required this.montoSolicitado,
    required this.plazoMeses,
    required this.tea,
    required this.conDesgravamen,
    required this.garantia,
    required this.destinoCredito,
    required this.estado,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      id: json['id'] ?? '',
      numeroExpediente: json['numero_expediente'] ?? '',
      montoSolicitado: (json['monto_solicitado'] ?? json['monto'] ?? 0).toDouble(),
      plazoMeses: json['plazo_meses'] ?? 0,
      tea: (json['tea'] ?? 0).toDouble(),
      conDesgravamen: json['con_desgravamen'] ?? true,
      garantia: json['garantia'] ?? '',
      destinoCredito: json['destino_credito'] ?? '',
      estado: json['estado'] ?? '',
    );
  }
}
