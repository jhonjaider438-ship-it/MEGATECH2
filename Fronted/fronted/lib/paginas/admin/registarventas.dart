import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/components/login/botonaaccionprincipal.dart';
import 'package:fronted/components/login/contenedorformulario.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/components/login/leertexto.dart';
import 'package:fronted/model/productos.dart';
import 'package:fronted/model/ventas.dart';
import 'package:fronted/paginas/admin/widets.dart/barranavega.dart';
import 'package:fronted/paginas/admin/widets.dart/resumenventa.dart';
import 'package:fronted/paginas/admin/widets.dart/seelcproducto.dart';
import 'package:fronted/paginas/admin/widets.dart/targetaitemventa.dart';
import 'package:fronted/service/ventas.dart';
import 'package:google_fonts/google_fonts.dart';

class Registarventas extends StatefulWidget {
  const Registarventas({super.key});

  @override
  State<Registarventas> createState() => _RegistarventasState();
}

class _RegistarventasState extends State<Registarventas> {
  final VentasService _service = VentasService();
  final TextEditingController _cedulaCtrl = TextEditingController();

  List<Producto> _productos = [];
  bool _cargandoProductos = true;
  String? _errorProductos;

  int _contadorUid = 0;
  late List<ItemVenta> _items;

  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _items = [_nuevoItem()];
    _cargarProductos();
  }

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    super.dispose();
  }

  ItemVenta _nuevoItem() => ItemVenta(uid: _contadorUid++);

  Future<void> _cargarProductos() async {
    setState(() {
      _cargandoProductos = true;
      _errorProductos = null;
    });
    try {
      final lista = await _service.obtenerProductos();
      if (!mounted) return;
      setState(() {
        _productos = lista;
        _cargandoProductos = false;
        // Sincroniza las líneas con el stock/precio recién traídos.
        for (final item in _items) {
          final actual = item.producto;
          if (actual == null) continue;
          final nuevo = lista.where((p) => p.id == actual.id);
          item.producto = nuevo.isEmpty ? null : nuevo.first;
          final p = item.producto;
          if (p != null && item.cantidad > p.stock) {
            item.cantidad = p.stock < 1 ? 1 : p.stock;
          }
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargandoProductos = false;
        _errorProductos = e.toString();
      });
    }
  }

  // ---------- Totales (solo visuales; el backend recalcula) ----------
  double get _total => _items.fold(0, (s, i) => s + i.subtotal);
  int get _unidades =>
      _items.where((i) => i.producto != null).fold(0, (s, i) => s + i.cantidad);
  int get _productosElegidos => _items.where((i) => i.producto != null).length;

  // ---------- Acciones ----------
  Future<void> _elegirProducto(ItemVenta item) async {
    if (_errorProductos != null || _productos.isEmpty) {
      _aviso(_errorProductos ?? 'No hay productos para mostrar');
      return;
    }
    FocusScope.of(context).unfocus();
    final bloqueados = _items
        .where((i) => i.uid != item.uid && i.producto != null)
        .map((i) => i.producto!.id)
        .toSet();

    final elegido = await mostrarSelectorProducto(
      context,
      productos: _productos,
      bloqueados: bloqueados,
    );
    if (elegido == null || !mounted) return;
    setState(() {
      item.producto = elegido;
      item.cantidad = 1;
    });
  }

  void _agregarItem() => setState(() => _items.add(_nuevoItem()));

  void _eliminarItem(ItemVenta item) {
    setState(() => _items.removeWhere((i) => i.uid == item.uid));
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _registrar() async {
    if (_enviando) return;

    final cedula = _cedulaCtrl.text.trim();
    if (cedula.isEmpty) {
      _aviso('Escribe la cédula del cliente');
      return;
    }
    if (_productosElegidos == 0) {
      _aviso('Agrega al menos un producto');
      return;
    }
    if (_productosElegidos != _items.length) {
      _aviso('Elige un producto en cada tarjeta o elimina las vacías');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _enviando = true);

    try {
      final idVendedor = await _service.idVendedorActual();
      if (idVendedor == null) {
        throw const VentaException(
          'No se pudo identificar al vendedor. Inicia sesión de nuevo.',
        );
      }

      final venta = await _service.registrarVenta(
        cedulaCliente: cedula,
        idVendedor: idVendedor,
        items: _items,
      );
      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DialogoVentaRegistrada(venta: venta),
      );
      if (!mounted) return;

      // Deja la pantalla lista para otra venta y refresca el stock.
      setState(() {
        _cedulaCtrl.clear();
        _items = [_nuevoItem()];
      });
      _cargarProductos();
    } on VentaException catch (e) {
      if (mounted) _aviso(e.mensaje);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  // ---------- UI ----------
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
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
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
                'Registrar venta',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1BC2F0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Contenedorformulario(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Leertexto(
                              label: 'Cédula del cliente',
                              controller: _cedulaCtrl,
                              keyboardType: TextInputType.number,
                              maxLength: 15,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Productos',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _estadoCatalogo(),
                      for (int i = 0; i < _items.length; i++) ...[
                        TarjetaItemVenta(
                          numero: i + 1,
                          item: _items[i],
                          onElegirProducto: () => _elegirProducto(_items[i]),
                          onCantidad: (c) =>
                              setState(() => _items[i].cantidad = c),
                          onEliminar: _items.length > 1
                              ? () => _eliminarItem(_items[i])
                              : null,
                        ),
                        const SizedBox(height: 14),
                      ],
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: _agregarItem,
                          icon: const Icon(Icons.add_circle_outline),
                          label: Text(
                            'Agregar otro producto',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.azulClaro,
                            side: const BorderSide(
                              color: AppColors.azulClaro,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      ResumenVenta(
                        productos: _productosElegidos,
                        unidades: _unidades,
                        total: _total,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Opacity(
                          opacity: _enviando ? 0.6 : 1,
                          child: Botonaaccionprincipal(
                            text: _enviando ? 'Registrando...' : 'Registrar venta',
                            width: 240,
                            height: 48,
                            onTap: _registrar,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Muestra el estado de la carga del catálogo (cargando / error con reintento).
  Widget _estadoCatalogo() {
    if (_cargandoProductos) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.azulClaro,
              ),
            ),
            SizedBox(width: 10),
            Text('Cargando productos...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }
    if (_errorProductos != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white54),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _errorProductos!,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: _cargarProductos,
              child: Text(
                'Reintentar',
                style: GoogleFonts.poppins(
                  color: AppColors.azulClaro,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}