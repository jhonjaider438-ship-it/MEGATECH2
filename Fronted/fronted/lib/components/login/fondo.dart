import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';

/// Fondo con degradado oscuro Azul fondo principal de todas las pantallas

class Fondo extends StatelessWidget {
  final Widget child;

  const Fondo({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.gradienteFondo),
      child: child,
    );
  }
}
