import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Texto centrado que resalta un correo (u otro dato clave), usado en las
/// pantallas de verificación para recordar a qué correo se envió el código.
class Correodestacado extends StatelessWidget {
  final String text;

  const Correodestacado({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: AppColors.azulEnlace,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}