import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Campo de texto con una etiqueta encima, usado en los formularios
class Leertexto extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final int? maxLength;
  final TextAlign textAlign;

  const Leertexto({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.maxLength,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.textoPrincipal,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          textAlign: textAlign,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.fondoCampo,
            suffixIcon: suffixIcon,
            counterText: maxLength != null ? '' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}