import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// SnackBar flotante con icono y borde de color.
void mostrarSnack(
  BuildContext context,
  String texto, {
  Color? color,
  IconData? icono,
}) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1F2937),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: color ?? AppColors.azulClaro),
        ),
        content: Row(
          children: [
            Icon(icono ?? Icons.info_outline, color: color ?? Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                texto,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
}

/// Atajo de [mostrarSnack] para errores (borde rojo).
void mostrarError(BuildContext context, String texto) => mostrarSnack(
  context,
  texto,
  color: Colors.redAccent,
  icono: Icons.error_outline,
);
