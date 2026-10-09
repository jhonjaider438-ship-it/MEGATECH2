import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TITULO DE SESCCION UNA PANTALLA PARA VENTAS

/// Título de sección dentro de una pantalla (ej. "Productos").
class TituloSeccion extends StatelessWidget {
  final String texto;

  const TituloSeccion(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
