import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';

/// Botón circular con degradado que regresa a la pantalla anterior.

class Botondevolver extends StatelessWidget {
  final VoidCallback? onTap;

  const Botondevolver({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 43,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: AppColors.gradienteBoton,
      ),
      child: Material(
        color: Colors.transparent,
        // este widets lo que hace es que lo que se eponga en pantalla lo vuenva interactivo ante
        // los toques y pueda realizar funciones
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap ?? () => Navigator.pop(context),
          child: const Center(
            child: Icon(Icons.undo, color: Colors.white, size: 27),
          ),
        ),
      ),
    );
  }
}
