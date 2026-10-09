import 'package:flutter/material.dart';
import 'package:fronted/components/login/botonaaccionprincipal.dart';
import 'package:fronted/components/login/contenedorformulario.dart';
import 'package:fronted/components/login/leertexto.dart';
import 'package:fronted/model/productos.dart';
import 'package:fronted/model/ventas.dart';
import 'package:fronted/paginas/admin/widets.dart/ventas/botoncontorno.dart';
import 'package:fronted/paginas/admin/widets.dart/estadocatalogo.dart';
import 'package:fronted/paginas/admin/widets.dart/ventas/mensajesnack.dart';
import 'package:fronted/paginas/admin/widets.dart/pantallaadmin.dart';
import 'package:fronted/paginas/admin/widets.dart/ventas/resumenventa.dart';
import 'package:fronted/paginas/admin/widets.dart/ventas/seelcproducto.dart';
import 'package:fronted/paginas/admin/widets.dart/ventas/targetaitemventa.dart';
import 'package:fronted/paginas/admin/widets.dart/tituloseccion.dart';
import 'package:fronted/service/ventas.dart';

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
      mostrarSnack(context, _errorProductos ?? 'No hay productos para mostrar');
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

  /// Devuelve el mensaje de error si la venta no se puede enviar, o null si es válida.
  String? _validar() {
    if (_cedulaCtrl.text.trim().isEmpty) return 'Escribe la cédula del cliente';
    if (_productosElegidos == 0) return 'Agrega al menos un producto';
    if (_productosElegidos != _items.length) {
      return 'Elige un producto en cada tarjeta o elimina las vacías';
    }
    return null;
  }

  Future<void> _registrar() async {
    if (_enviando) return;

    final error = _validar();
    if (error != null) {
      mostrarSnack(context, error);
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
        cedulaCliente: _cedulaCtrl.text.trim(),
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
      if (mounted) mostrarSnack(context, e.mensaje);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return PantallaAdmin(
      titulo: 'Registrar venta',
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Contenedorformulario(
              child: Leertexto(
                label: 'Cédula del cliente',
                controller: _cedulaCtrl,
                keyboardType: TextInputType.number,
                maxLength: 15,
              ),
            ),
            const SizedBox(height: 22),
            const TituloSeccion('Productos'),
            const SizedBox(height: 10),
            EstadoCatalogo(
              cargando: _cargandoProductos,
              error: _errorProductos,
              onReintentar: _cargarProductos,
            ),
            for (int i = 0; i < _items.length; i++) ...[
              TarjetaItemVenta(
                numero: i + 1,
                item: _items[i],
                onElegirProducto: () => _elegirProducto(_items[i]),
                onCantidad: (c) => setState(() => _items[i].cantidad = c),
                onEliminar: _items.length > 1
                    ? () => _eliminarItem(_items[i])
                    : null,
              ),
              const SizedBox(height: 14),
            ],
            Center(
              child: BotonContorno(
                texto: 'Agregar otro producto',
                onTap: _agregarItem,
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
    );
  }
}
