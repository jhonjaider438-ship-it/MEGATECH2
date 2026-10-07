import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/model/productos.dart';
import 'package:fronted/paginas/admin/widets.dart/barranavega.dart';
import 'package:fronted/paginas/admin/widets.dart/targetaproducto.dart';
import 'package:fronted/service/productoservice.dart';
import 'package:google_fonts/google_fonts.dart';

class Bajostock extends StatefulWidget {
  const Bajostock({super.key});

  @override
  State<Bajostock> createState() => _BajostockState();
}

class _BajostockState extends State<Bajostock> {
  final ProductosService _service = ProductosService();
  late Future<List<Producto>> _futuroProductos;

  @override
  void initState() {
    super.initState();
    _futuroProductos = _service.obtenerListaBajoStock();
  }

  /// Vuelve a pedir los datos al backend (botón "Reintentar" y pull-to-refresh)
  Future<void> _recargar() async {
    setState(() {
      _futuroProductos = _service.obtenerListaBajoStock();
    });
    await _futuroProductos.catchError((_) => <Producto>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Barranavegacioninferior(
        botones: [
          BotonNav(
            icon: Icons.arrow_back,
            size: 26,
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Fondo(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 20,
                ),
                child: Center(
                  child: Text(
                    'Megatech 2',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(
                'Productos en bajo stock',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1BC2F0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<Producto>>(
                  future: _futuroProductos,
                  builder: (context, snapshot) {
                    // 1) Cargando
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.azulClaro,
                        ),
                      );
                    }

                    // 2) Error
                    if (snapshot.hasError) {
                      return _mensaje(
                        icono: Icons.wifi_off_rounded,
                        texto: 'No se pudieron cargar los productos',
                        conBoton: true,
                      );
                    }

                    // 3) Sin productos en bajo stock
                    final productos = snapshot.data ?? [];
                    if (productos.isEmpty) {
                      return _mensaje(
                        icono: Icons.check_circle_outline_rounded,
                        texto: '¡Todo en orden! No hay productos en bajo stock',
                      );
                    }

                    // 4) Lista de tarjetas
                    return RefreshIndicator(
                      color: AppColors.azulClaro,
                      onRefresh: _recargar,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                        itemCount: productos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, i) =>
                            TarjetaProductoBajo(producto: productos[i]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mensaje({
    required IconData icono,
    required String texto,
    bool conBoton = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: Colors.white54, size: 56),
            const SizedBox(height: 12),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15),
            ),
            if (conBoton) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _recargar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3FA9F5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
