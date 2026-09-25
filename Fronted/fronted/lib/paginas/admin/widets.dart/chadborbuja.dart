// lib/paginas/admin/widets.dart/burbujamensaje.dart
//
// Componente reutilizable, mismo estilo que Targetas (bordes redondeados,
// paleta AppColors, GoogleFonts.poppins).

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fronted/colores/stilocolores.dart';

class BurbujaMensaje extends StatelessWidget {
  final String mensaje;
  final bool esUsuario; // true = lo escribio el admin, false = respuesta IA

  const BurbujaMensaje({
    super.key,
    required this.mensaje,
    required this.esUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: esUsuario ? AppColors.azulOscuro : AppColors.fondoTarjeta,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(esUsuario ? 16 : 2),
            bottomRight: Radius.circular(esUsuario ? 2 : 16),
          ),
          border: Border.all(
            color: esUsuario ? AppColors.azulClaro : AppColors.bordeTarjeta,
            width: 1,
          ),
        ),
        child: Text(
          mensaje,
          style: GoogleFonts.poppins(
            color: AppColors.textoPrincipal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}