import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Botón de acción principal con degradado (usado para "Iniciar sesion",

class Botonaaccionprincipal extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;

  const Botonaaccionprincipal({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 185,
    this.height = 42,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: AppColors.gradienteBoton,
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.acme(
              color: AppColors.textoBoton,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
