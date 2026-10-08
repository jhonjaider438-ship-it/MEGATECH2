import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/pedidos.dart' show formatearPesos;
import 'package:fronted/model/productos.dart';
import 'package:fronted/model/ventas.dart';
import 'package:fronted/paginas/admin/widets.dart/seelcproducto.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tarjeta de un producto dentro de la venta: selector de producto,
/// cantidad y subtotal de esa línea.
class TarjetaItemVenta extends StatelessWidget {
  final int numero;
  final ItemVenta item;
  final VoidCallback onElegirProducto;
  final ValueChanged<int> onCantidad;
  final VoidCallback? onEliminar;

  const TarjetaItemVenta({
    super.key,
    required this.numero,
    required this.item,
    required this.onElegirProducto,
    required this.onCantidad,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final p = item.producto;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.bordeTarjeta, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Producto $numero',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onEliminar != null)
                InkWell(
                  onTap: onEliminar,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFFF5252),
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _campoProducto(p),
          if (p != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cantidad',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _stepper(p.stock),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Disponibles: ${p.stock}',
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11),
              ),
            ),
            const Divider(color: Colors.white12, height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Subtotal',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  formatearPesos(item.subtotal),
                  style: GoogleFonts.poppins(
                    color: AppColors.azulClaro,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _campoProducto(Producto? p) {
    return InkWell(
      onTap: onElegirProducto,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.fondoCampo,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            if (p != null) ...[
              FotoProducto(url: p.foto, tam: 46),
              const SizedBox(width: 10),
            ] else ...[
              const Icon(Icons.search, color: Colors.black54),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: p == null
                  ? Text(
                      'Toca para elegir un producto',
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.nombre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID ${p.id}  ·  ${formatearPesos(p.precio)} c/u',
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _stepper(int stock) {
    Widget boton(IconData icono, VoidCallback? onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: onTap == null ? null : AppColors.gradienteBoton,
            color: onTap == null ? Colors.white12 : null,
          ),
          child: Icon(
            icono,
            color: onTap == null ? Colors.white30 : Colors.black,
            size: 20,
          ),
        ),
      );
    }

    return Row(
      children: [
        boton(
          Icons.remove,
          item.cantidad > 1 ? () => onCantidad(item.cantidad - 1) : null,
        ),
        SizedBox(
          width: 46,
          child: Text(
            '${item.cantidad}',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        boton(
          Icons.add,
          item.cantidad < stock ? () => onCantidad(item.cantidad + 1) : null,
        ),
      ],
    );
  }
}