import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fila con un texto informativo y un enlace de acción, p. ej.
/// "¿No tienes cuenta?" + "Regístrate aquí".

class Notienesregister extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onTap;

  const Notienesregister({
    super.key,
    required this.question,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          question,
          style: GoogleFonts.poppins(
            color: AppColors.textoPrincipal,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: GoogleFonts.poppins(
              color: AppColors.azulEnlace,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
