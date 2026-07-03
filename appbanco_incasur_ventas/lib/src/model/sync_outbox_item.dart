class SyncOutboxItem {
  final String id;
  final String operacion;
  final Map<String, dynamic> datosJson;
  final bool pendienteSync;
  final DateTime creadoEn;

  SyncOutboxItem({
    required this.id,
    required this.operacion,
    required this.datosJson,
    required this.pendienteSync,
    required this.creadoEn,
  });

  Map<String, dynamic> toJson() => {
    'operacion': operacion,
    'datos_json': datosJson,
    'pendiente_sync': pendienteSync,
    'creado_en': creadoEn.toIso8601String(),
  };

  factory SyncOutboxItem.fromJson(Map<String, dynamic> json) => SyncOutboxItem(
    id: json['id'] ?? '',
    operacion: json['operacion'] ?? '',
    datosJson: Map<String, dynamic>.from(json['datos_json'] ?? {}),
    pendienteSync: json['pendiente_sync'] ?? true,
    creadoEn: DateTime.tryParse(json['creado_en'] ?? '') ?? DateTime.now(),
  );
}
