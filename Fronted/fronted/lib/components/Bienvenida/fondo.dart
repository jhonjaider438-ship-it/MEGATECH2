import 'package:flutter/material.dart';

class FondoDegradado extends StatefulWidget {
  final Widget child;
  // Colores por defecto = los de Bienvenida. Cualquier otra pantalla
  // (como Recuperapass) puede pasar su propia paleta aquí.
  final List<Color> colores;

  const FondoDegradado({
    super.key,
    required this.child,
    this.colores = const [
      Color(0xFF173A55),
      Color(0xFF0B202E),
      Color(0xFF06141D),
    ],
  });

  @override
  State<FondoDegradado> createState() => _FondoDegradadoState();
}

class _FondoDegradadoState extends State<FondoDegradado> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.colores,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
