import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/pedidos.dart' show formatearPesos;
import 'package:fronted/model/productos.dart';
import 'package:google_fonts/google_fonts.dart';

// LOS PRODUCTOS QUE APARECEN EN EL SELECTOR PATRA SELECIONAROS EN LA VENTA

/// Miniatura de un producto (con placeholder si no hay foto o falla).
class FotoProducto extends StatelessWidget {
  final String? url;
  final double tam;

  const FotoProducto({super.key, required this.url, this.tam = 56});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: tam,
      height: tam,
      color: AppColors.fondoOscuro2,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.white38,
        size: tam * 0.4,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: url == null
          ? placeholder
          : Image.network(
              url!,
              width: tam,
              height: tam,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}

/// Abre el buscador de productos y devuelve el elegido (o null si cierra).
/// [bloqueados] = ids que ya están en otra tarjeta de la venta.
Future<Producto?> mostrarSelectorProducto(
  BuildContext context, {
  required List<Producto> productos,
  required Set<int> bloqueados,
}) {
  return showModalBottomSheet<Producto>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _SelectorProducto(productos: productos, bloqueados: bloqueados),
  );
}

class _SelectorProducto extends StatefulWidget {
  final List<Producto> productos;
  final Set<int> bloqueados;

  const _SelectorProducto({required this.productos, required this.bloqueados});

  @override
  State<_SelectorProducto> createState() => _SelectorProductoState();
}

class _SelectorProductoState extends State<_SelectorProducto> {
  final TextEditingController _busqueda = TextEditingController();
  String _texto = '';

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  List<Producto> get _filtrados {
    final q = _texto.trim().toLowerCase();
    if (q.isEmpty) return widget.productos;
    return widget.productos.where((p) {
      return p.nombre.toLowerCase().contains(q) ||
          p.id.toString() == q ||
          (p.subcategoria ?? '').toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height * 0.85;
    final lista = _filtrados;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: alto,
        decoration: BoxDecoration(
          color: AppColors.fondoOscuro2,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: AppColors.bordeTarjeta, width: 1),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Elegir producto',
              style: GoogleFonts.poppins(
                color: AppColors.azulClaro,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                controller: _busqueda,
                onChanged: (v) => setState(() => _texto = v),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre o ID',
                  hintStyle: GoogleFonts.poppins(fontSize: 14),
                  filled: true,
                  fillColor: AppColors.fondoCampo,
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  suffixIcon: _texto.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            _busqueda.clear();
                            setState(() => _texto = '');
                          },
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: lista.isEmpty
                  ? Center(
                      child: Text(
                        'No hay productos con esa búsqueda',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      itemCount: lista.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _fila(lista[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(Producto p) {
    final agotado = p.stock <= 0;
    final yaAgregado = widget.bloqueados.contains(p.id);
    final deshabilitado = agotado || yaAgregado;
    final etiqueta = agotado
        ? 'Agotado'
        : yaAgregado
        ? 'Ya agregado'
        : null;

    return Opacity(
      opacity: deshabilitado ? 0.45 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: deshabilitado ? null : () => Navigator.pop(context, p),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              FotoProducto(url: p.foto),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      etiqueta ?? 'ID ${p.id}  ·  Stock ${p.stock}',
                      style: GoogleFonts.poppins(
                        color: etiqueta != null
                            ? const Color(0xFFFFA726)
                            : Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatearPesos(p.precio),
                style: GoogleFonts.poppins(
                  color: AppColors.azulClaro,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
