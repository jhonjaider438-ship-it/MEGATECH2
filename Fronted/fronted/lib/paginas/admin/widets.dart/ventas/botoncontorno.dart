import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

// ESTE ES EL BOTON DE REGISTRAR VENTAS QUE DICE AGREGAR OTRO PRODUCTO

/// Botón secundario redondeado, solo con borde azul (ej. "Agregar otro producto").
class BotonContorno extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback? onTap;

  const BotonContorno({
    super.key,
    required this.texto,
    required this.onTap,
    this.icono = Icons.add_circle_outline,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icono),
      label: Text(
        texto,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.azulClaro,
        side: const BorderSide(color: AppColors.azulClaro, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}
