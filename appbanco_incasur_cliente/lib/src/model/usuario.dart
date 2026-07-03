class Usuario {
  final String id;
  final String dni;
  final String rol;
  final String nombreCompleto;

  Usuario({
    required this.id,
    required this.dni,
    required this.rol,
    required this.nombreCompleto,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? '',
      dni: json['dni'] ?? '',
      rol: json['rol'] ?? '',
      nombreCompleto: json['nombre_completo'] ?? '',
    );
  }
}
