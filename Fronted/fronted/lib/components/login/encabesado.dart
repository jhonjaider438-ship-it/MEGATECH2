import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Encabezado con ícono + título + subtítulo, usado al inicio de las

class Encabesado extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const Encabesado({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.person_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textoPrincipal, size: 65),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.textoPrincipal,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: AppColors.textoPrincipal,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
