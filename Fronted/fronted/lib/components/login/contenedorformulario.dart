import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';

/// Tarjeta oscura con borde, usada como contenedor de los formularios

class Contenedorformulario extends StatelessWidget {
  final Widget child;

  const Contenedorformulario({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.bordeTarjeta, width: 1),
      ),
      child: child,
    );
  }
}
