import 'package:flutter/material.dart';

/// Texto con degradado, versión StatefulWidget.
/// No necesita estado propio, pero se estructura con State
/// para que veas la sintaxis. initState() se ejecuta 1 sola vez,
/// cuando el widget se crea.
class TextoDegradado extends StatefulWidget {
  final String texto;
  final double fontSize;
  final FontWeight fontWeight;
  final List<Color> colores;

  const TextoDegradado({
    super.key,
    required this.texto,
    this.fontSize = 32,
    this.fontWeight = FontWeight.bold,
    this.colores = const [Color(0xFF29B6F6), Color(0xFF0288D1)],
  });

  @override
  State<TextoDegradado> createState() => _TextoDegradadoState();
}

class _TextoDegradadoState extends State<TextoDegradado> {
  @override
  void initState() {
    super.initState();
    // Aquí podrías inicializar algo, por ejemplo un controller
    // de animación. En este caso no hace falta nada.
  }

  @override
  Widget build(BuildContext context) {
    // Dentro de un State, los parámetros del widget se leen con "widget."
    return ShaderMask(
      shaderCallback: (bounds) =>
          LinearGradient(colors: widget.colores).createShader(bounds),
      child: Text(
        widget.texto,
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
      ),
    );
  }
}
