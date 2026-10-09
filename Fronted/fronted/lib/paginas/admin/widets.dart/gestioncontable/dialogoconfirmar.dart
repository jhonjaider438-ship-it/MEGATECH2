import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Diálogo de confirmación genérico. Devuelve true solo si el usuario confirma.
Future<bool> confirmarAccion(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String textoConfirmar = 'Eliminar',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.fondoTarjeta,
      title: Text(titulo, style: GoogleFonts.poppins(color: Colors.white)),
      content: Text(
        mensaje,
        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            textoConfirmar,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );
  return ok == true;
}