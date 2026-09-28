import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Aviso al pie del formulario indicando que los datos están protegidos.

class Datosprotejidos extends StatelessWidget {
  final String text;

  const Datosprotejidos({
    super.key,
    this.text =
        'Tus datos estan protegidos con nivel de incriptacion empresarial',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_outline,
          color: AppColors.textoPrincipal,
          size: 16,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.textoPrincipal,
              fontSize: 8,
            ),
          ),
        ),
      ],
    );
  }
}
