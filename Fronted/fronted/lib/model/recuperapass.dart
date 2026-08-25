class RecuperarModel {
  final String correo;

  RecuperarModel({
    required this.correo,
  });

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
    };
  }
}