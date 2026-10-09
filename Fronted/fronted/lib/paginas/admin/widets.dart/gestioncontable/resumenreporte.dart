import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/gestioncontable.dart';
import 'package:google_fonts/google_fonts.dart';

// ESTE NOS DA UN RESUEN DEL REPORTE TODOS LS DATOS

/// Cuadrícula 2x2 con los totales del reporte.
class ResumenReporteGrid extends StatelessWidget {
  final ResumenReporte resumen;

  const ResumenReporteGrid({super.key, required this.resumen});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.3,
      children: [
        _Dato(
          'Total vendido',
          moneda(resumen.totalVendido),
          Icons.attach_money_rounded,
        ),
        _Dato(
          'Ventas',
          '${resumen.cantidadVentas}',
          Icons.receipt_long_rounded,
        ),
        _Dato(
          'Unidades',
          '${resumen.unidadesVendidas}',
          Icons.inventory_2_outlined,
        ),
        _Dato(
          'Líneas de detalle',
          '${resumen.cantidadDetalles}',
          Icons.list_alt_rounded,
        ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _Dato(this.titulo, this.valor, this.icono);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordeTarjeta),
      ),
      child: Row(
        children: [
          Icon(icono, color: AppColors.azulClaro),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    valor,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
