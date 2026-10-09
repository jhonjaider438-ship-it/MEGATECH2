import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/gestioncontable.dart';
import 'package:google_fonts/google_fonts.dart';

// TAREGTA DONDE SE MUESTRAN LA VENTAS ECHAS

/// Tarjeta desplegable de una venta con sus productos.
class TarjetaVentaContable extends StatelessWidget {
  final VentaContable venta;
  final VoidCallback? onEliminar;

  const TarjetaVentaContable({super.key, required this.venta, this.onEliminar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.bordeTarjeta, width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.azulClaro,
          collapsedIconColor: Colors.white70,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          title: Text(
            'Venta #${venta.id}',
            style: GoogleFonts.poppins(
              color: AppColors.azulClaro,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            '${fechaCorta(venta.fecha)}'
            '${venta.vendedor.isNotEmpty ? '\n${venta.vendedor}' : ''}',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
          trailing: Text(
            moneda(venta.total),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          children: [
            for (final d in venta.detalles)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.producto,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${d.cantidad} x ${moneda(d.precioUnitario)}'
                            '${d.categoria.isNotEmpty ? '  ·  ${d.categoria}' : ''}',
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      moneda(d.subtotal),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            if (onEliminar != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onEliminar,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  label: Text(
                    'Eliminar venta',
                    style: GoogleFonts.poppins(color: Colors.redAccent),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
