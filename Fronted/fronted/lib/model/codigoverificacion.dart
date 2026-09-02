class VerificarCodigoModel {
  final String correo;
  final String codigo;
  final String nuevacontrasena;

  VerificarCodigoModel({
    required this.correo,
    required this.codigo,
    required this.nuevacontrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'codigo': codigo,
      'nuevacontraseña': nuevacontrasena,
    };
  }
}