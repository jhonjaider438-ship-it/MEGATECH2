import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/components/codigo_verifi/iconocirculodegradado.dart';
import 'package:fronted/model/pedidos.dart' show formatearPesos;
import 'package:fronted/model/ventas.dart';
import 'package:google_fonts/google_fonts.dart';

// ESTE MUESTRA EL RESUEMN DE LA VENTA QUE SE VA A HACER

/// Panel con el resumen de la venta: productos, unidades y total final.
class ResumenVenta extends StatelessWidget {
  final int productos;
  final int unidades;
  final double total;

  const ResumenVenta({
    super.key,
    required this.productos,
    required this.unidades,
    required this.total,
  });

  Widget _fila(String label, String valor) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
        ),
        Text(
          valor,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.bordeTarjeta, width: 1),
      ),
      child: Column(
        children: [
          _fila('Productos', '$productos'),
          const SizedBox(height: 6),
          _fila('Unidades', '$unidades'),
          const Divider(color: Colors.white12, height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                formatearPesos(total),
                style: GoogleFonts.poppins(
                  color: AppColors.azulClaro,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Diálogo que confirma que la venta quedó registrada.
class DialogoVentaRegistrada extends StatelessWidget {
  final VentaRegistrada venta;

  const DialogoVentaRegistrada({super.key, required this.venta});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF10243F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IconoCirculoDegradado(
            icono: Icons.check,
            tamano: 80,
            tamanoIcono: 45,
          ),
          const SizedBox(height: 20),
          Text(
            '¡Venta registrada!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Venta #${venta.id}',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          Text(
            formatearPesos(venta.total),
            style: GoogleFonts.poppins(
              color: AppColors.azulClaro,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (venta.fecha.isNotEmpty)
            Text(
              venta.fecha,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
            ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AEEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Registrar otra venta',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
