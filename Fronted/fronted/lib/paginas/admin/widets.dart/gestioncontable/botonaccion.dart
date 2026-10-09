import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

/// Botón azul de ancho completo con icono; muestra un spinner si [cargando].
class BotonAccion extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback? onTap;
  final bool cargando;

  const BotonAccion({
    super.key,
    required this.texto,
    required this.icono,
    required this.onTap,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: cargando ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.azulClaro,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        icon: cargando
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icono),
        label: Text(
          texto,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
