class VerificarCodigoModel {
  final String correo;
  final String codigo;
  final String nuevaContrasena;

  VerificarCodigoModel({
    required this.correo,
    required this.codigo,
    required this.nuevaContrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'codigo': codigo,
      'nuevacontraseña': nuevaContrasena,
    };
  }
}