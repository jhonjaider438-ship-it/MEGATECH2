import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

class Datoperfil extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const Datoperfil({super.key, required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              color: AppColors.textoPrincipal,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            valor,
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              color: AppColors.textoPrincipal,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
