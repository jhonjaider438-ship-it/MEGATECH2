import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/pedidos.dart' show formatearPesos;
import 'package:fronted/model/productos.dart';
import 'package:fronted/paginas/admin/widets.dart/pedido/targetapedido.dart'
    show FotoCuadrada;
import 'package:google_fonts/google_fonts.dart';

/// Tarjeta de producto para el cliente: solo foto, nombre, descripción y precio.
class TarjetaProductoCliente extends StatelessWidget {
  final Producto producto;

  const TarjetaProductoCliente({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.bordeTarjeta, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FotoCuadrada(url: producto.foto),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  producto.descripcion,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatearPesos(producto.precio),
                  style: GoogleFonts.poppins(
                    color: AppColors.azulClaro,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
