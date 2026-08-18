class usermodel {
  final String? id;
  final String? cedula;
  final String? nombre;
  final String? apellido;
  final String? telefono;
  final String? correo;
  final String? contrasena;
  final String? rol;

  usermodel ({
    this.id,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
    required this.contrasena,
    this.rol = 'Cliente',
  });

  // mapear la respuesta de la base de datos 
  factory usermodel.fromJson(Map<String, dynamic> json) {
    return usermodel(
      id: json['id']?.toString(),
      cedula: json['cedula'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
      contrasena: json['contraseña'] ?? '',
      rol: json['rol'] ?? 'Cliente',
    );
  }

  // combertir el map y enviarlo al post
  Map<String, dynamic> toJson() {
    return {
      "cedula": cedula,
      "nombre": nombre,
      "apellido": apellido,
      "telefono": telefono,
      "correo": correo,
      "contraseña": contrasena,
      "rol": rol,
    };
  }

}