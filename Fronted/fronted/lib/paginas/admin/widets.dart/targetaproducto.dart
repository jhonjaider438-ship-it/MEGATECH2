import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/productos.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tarjeta de un producto con bajo stock: foto, nombre, descripción,
/// precio y una etiqueta con el stock restante.
/// Mismo color de fondo y radio que [Targetas] para que se vea igual.
class TarjetaProductoBajo extends StatelessWidget {
  final Producto producto;

  const TarjetaProductoBajo({super.key, required this.producto});

  static const Color _rojo = Color(0xFFFF5252);
  static const Color _naranja = Color(0xFFFFA726);

  bool get _agotado => producto.stock <= 0;
  Color get _colorAlerta => _agotado ? _rojo : _naranja;

  /// 1500000 -> $1.500.000
  String _formatearPrecio(double precio) {
    final entero = precio.round().toString();
    final conPuntos = entero.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    return '\$$conPuntos';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: _colorAlerta, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _foto(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _etiquetaStock(),
                const SizedBox(height: 6),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatearPrecio(producto.precio),
                  style: GoogleFonts.poppins(
                    color: AppColors.azulClaro,
                    fontSize: 17,
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

  Widget _foto() {
    const double tam = 105;
    final placeholder = Container(
      width: tam,
      height: tam,
      color: AppColors.fondoOscuro2,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.white38,
        size: 34,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: producto.foto == null
          ? placeholder
          : Image.network(
              producto.foto!,
              width: tam,
              height: tam,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progreso) {
                if (progreso == null) return child;
                return Container(
                  width: tam,
                  height: tam,
                  color: AppColors.fondoOscuro2,
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.azulClaro,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }

  Widget _etiquetaStock() {
    final texto = _agotado
        ? 'Agotado'
        : producto.stock == 1
        ? 'Queda 1 unidad'
        : 'Quedan ${producto.stock} unidades';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _colorAlerta.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _colorAlerta, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, color: _colorAlerta, size: 14),
          const SizedBox(width: 4),
          Text(
            texto,
            style: GoogleFonts.poppins(
              color: _colorAlerta,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
