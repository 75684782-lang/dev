class Cuota {
  final int numero;
  final String fechaPago;
  final double montoCuota;
  final double capital;
  final double interes;
  final double saldoPendiente;

  Cuota({
    required this.numero,
    required this.fechaPago,
    required this.montoCuota,
    required this.capital,
    required this.interes,
    required this.saldoPendiente,
  });

  factory Cuota.fromJson(Map<String, dynamic> json) {
    return Cuota(
      numero: json['cuota'] ?? json['numero'] ?? 0,
      fechaPago: json['fecha'] ?? json['fecha_pago'] ?? '',
      montoCuota: (json['monto'] ?? json['monto_cuota'] ?? 0).toDouble(),
      capital: (json['capital'] ?? 0).toDouble(),
      interes: (json['interes'] ?? 0).toDouble(),
      saldoPendiente: (json['saldo'] ?? json['saldo_pendiente'] ?? 0).toDouble(),
    );
  }
}
