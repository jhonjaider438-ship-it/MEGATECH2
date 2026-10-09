import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/pedidos.dart';
import 'package:fronted/paginas/admin/widets.dart/pedido/targetapedido.dart';
import 'package:google_fonts/google_fonts.dart';


// ESTA ES LA TARGETA QUE MUESTRA CADA PRODUCTO DEL PEDIDO

/// Un artículo del pedido: foto, nombre, descripción, cantidad × precio y subtotal.
class TarjetaArticuloPedido extends StatelessWidget {
  final ArticuloPedido articulo;

  const TarjetaArticuloPedido({super.key, required this.articulo});

  @override
  Widget build(BuildContext context) {
    final a = articulo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.bordeTarjeta.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FotoCuadrada(url: a.foto, tam: 90, radio: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  a.descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  '${a.cantidad} × ${formatearPesos(a.precioUnitario)}',
                  style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                ),
                Row(
                  children: [
                    Text(
                      'Subtotal  ',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        formatearPesos(a.subtotal),
                        style: GoogleFonts.poppins(
                          color: AppColors.azulClaro,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}