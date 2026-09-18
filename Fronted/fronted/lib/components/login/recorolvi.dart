import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fila con el checkbox "Recordarme" y el enlace "¿Olvidaste la contraseña?".
class Recorolvi extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onForgotPassword;

  const Recorolvi({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
            Text(
              'Recordarme',
              style: GoogleFonts.poppins(
                color: AppColors.textoPrincipal,
                fontSize: 9,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onForgotPassword,
          child: Text(
            '¿Olvidaste la contraseña?',
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
