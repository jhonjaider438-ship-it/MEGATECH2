import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fila con checkbox + texto de "Acepto los términos y condiciones".
class Terminoscondiciones extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String text;

  const Terminoscondiciones({
    super.key,
    required this.value,
    required this.onChanged,
    this.text =
        'Acepto los terminos y condiciones y la politica de privacidad',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: AppColors.textoPrincipal,
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }
}