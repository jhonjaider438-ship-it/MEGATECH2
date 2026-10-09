import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/gestioncontable.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/chipsselec.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/dialogoconfirmar.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/targetaventacontable.dart';
import 'package:fronted/paginas/admin/widets.dart/listaasincrona.dart';
import 'package:fronted/paginas/admin/widets.dart/pedido/buscarpedido.dart';
import 'package:fronted/paginas/admin/widets.dart/ventas/mensajesnack.dart';
import 'package:fronted/service/gestioncontable.dart';
import 'package:google_fonts/google_fonts.dart';

enum _Modo { todas, cliente, vendedor }

// ESTE ES EL PANEL DE VENTAS

/// Pestaña "Ventas": todas / por cédula de cliente / por cédula de vendedor.
class TabVentas extends StatefulWidget {
  const TabVentas({super.key});

  @override
  State<TabVentas> createState() => _TabVentasState();
}

class _TabVentasState extends State<TabVentas>
    with AutomaticKeepAliveClientMixin {
  final _service = ContableService();
  final _cedulaCtrl = TextEditingController();

  _Modo _modo = _Modo.todas;
  String _titulo = 'Todas las ventas';
  List<VentaContable> _ventas = [];
  late Future<List<VentaContable>> _futuro;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futuro = _cargar();
  }

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    super.dispose();
  }

  /// Trae las ventas según el modo y guarda título y lista para el encabezado.
  Future<List<VentaContable>> _cargar() async {
    final cedula = _cedulaCtrl.text.trim();
    final b = switch (_modo) {
      _Modo.todas => BusquedaVentas(
        titulo: 'Todas las ventas',
        ventas: await _service.listarVentas(),
      ),
      _Modo.cliente => await _service.comprasPorCedula(cedula),
      _Modo.vendedor => await _service.ventasPorCedulaVendedor(cedula),
    };
    if (mounted) {
      setState(() {
        _titulo = b.titulo;
        _ventas = b.ventas;
      });
    }
    return b.ventas;
  }

  Future<void> _recargar() async {
    setState(() => _futuro = _cargar());
    await _futuro.catchError((_) => <VentaContable>[]);
  }

  void _buscar() {
    if (_modo != _Modo.todas && _cedulaCtrl.text.trim().isEmpty) {
      return mostrarError(context, 'Escribe una cédula para buscar');
    }
    FocusScope.of(context).unfocus();
    _recargar();
  }

  Future<void> _eliminar(VentaContable v) async {
    final ok = await confirmarAccion(
      context,
      titulo: 'Eliminar venta #${v.id}',
      mensaje:
          'Se borrará la venta y el stock de sus productos se devolverá '
          'al inventario. Esta acción no se puede deshacer.',
    );
    if (!ok) return;

    try {
      await _service.eliminarVenta(v.id);
      if (!mounted) return;
      mostrarSnack(context, 'Venta eliminada y stock devuelto');
      _recargar();
    } on ContableException catch (e) {
      if (mounted) mostrarError(context, e.mensaje);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final total = _ventas.fold<double>(0, (s, v) => s + v.total);

    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ChipsSeleccion<_Modo>(
              opciones: const {
                _Modo.todas: 'Todas',
                _Modo.cliente: 'Por cliente',
                _Modo.vendedor: 'Por vendedor',
              },
              valor: _modo,
              onCambio: (m) {
                setState(() => _modo = m);
                if (m == _Modo.todas) _buscar(); // "Todas" no necesita cédula
              },
            ),
          ),
        ),
        if (_modo != _Modo.todas) ...[
          const SizedBox(height: 10),
          BarraBusquedaCedula(
            controller: _cedulaCtrl,
            hintText:
                'Cédula del ${_modo == _Modo.cliente ? 'cliente' : 'vendedor'}',
            hayBusqueda: false,
            onBuscar: _buscar,
            onLimpiar: () {},
          ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _titulo,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${_ventas.length} · ${moneda(total)}',
                style: GoogleFonts.poppins(
                  color: AppColors.azulClaro,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListaAsincrona<VentaContable>(
            futuro: _futuro,
            onRecargar: _recargar,
            textoError: 'No se pudieron cargar las ventas',
            textoVacio: 'No hay ventas para mostrar',
            iconoVacio: Icons.receipt_long_outlined,
            itemBuilder: (_, v) =>
                TarjetaVentaContable(venta: v, onEliminar: () => _eliminar(v)),
          ),
        ),
      ],
    );
  }
}
