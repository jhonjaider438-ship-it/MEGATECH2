import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

// ESTE MANEJA LOS PEQUEÑOS MENSAJES DE ERROR SI SE ENCENTRN O NO LOS PRODUCTOS

/// Franja pequeña que informa el estado de una carga dentro de un formulario:
/// "Cargando..." con spinner, o el error con botón "Reintentar".
/// Si no está cargando y no hay error, no ocupa espacio.
///
/// (Para estados de pantalla completa usa [MensajeEstado] de listaasincrona.dart.)
class EstadoCatalogo extends StatelessWidget {
  final bool cargando;
  final String? error;
  final VoidCallback onReintentar;
  final String textoCargando;

  const EstadoCatalogo({
    super.key,
    required this.cargando,
    required this.error,
    required this.onReintentar,
    this.textoCargando = 'Cargando productos...',
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.azulClaro,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              textoCargando,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white54),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                error!,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: onReintentar,
              child: Text(
                'Reintentar',
                style: GoogleFonts.poppins(
                  color: AppColors.azulClaro,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
