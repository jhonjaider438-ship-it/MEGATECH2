import 'package:flutter/material.dart';

class IconoCirculoDegradado extends StatefulWidget {
  final IconData icono;
  final double tamano;
  final double tamanoIcono;

  const IconoCirculoDegradado({
    super.key,
    required this.icono,
    this.tamano = 75,
    this.tamanoIcono = 40,
  });

  @override
  State<IconoCirculoDegradado> createState() => _IconoCirculoDegradadoState();
}

class _IconoCirculoDegradadoState extends State<IconoCirculoDegradado> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.tamano,
      height: widget.tamano,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
        ),
      ),
      child: Icon(widget.icono, color: Colors.white, size: widget.tamanoIcono),
    );
  }
}
