import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tarjeta compacta para mostrar un numero + una etiqueta (el resumen del
/// dashboard). Mismo color, borde y padding que [Targetas]; la altura se
/// iguala a la tarjeta vecina con IntrinsicHeight desde homeadmin.dart, no
/// con un numero fijo, para que nunca se desborde con textos largos.
class Tarjetaestadistica extends StatelessWidget {
  final String valor;
  final String etiqueta;
  final Color colorValor;
  final Color colorBorde;

  const Tarjetaestadistica({
    super.key,
    required this.valor,
    required this.etiqueta,
    required this.colorValor,
    required this.colorBorde,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: colorBorde, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            valor,
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: colorValor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
