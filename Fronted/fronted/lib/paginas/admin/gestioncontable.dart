import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/model/gestioncontable.dart';
import 'package:fronted/paginas/admin/widets.dart/barranavega.dart';
import 'package:fronted/paginas/admin/widets.dart/targetaventacontable.dart';
import 'package:fronted/service/gestioncontable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

// ---------------------------------------------------------------------------
// Utilidades compartidas por las dos pestañas
// ---------------------------------------------------------------------------

void _aviso(BuildContext context, String texto, {bool error = false}) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(texto, style: GoogleFonts.poppins()),
        backgroundColor: error ? Colors.red.shade700 : AppColors.azulOscuro,
      ),
    );
}

Widget _mensajeVacio(IconData icono, String texto) => Center(
  child: Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, color: Colors.white54, size: 52),
        const SizedBox(height: 10),
        Text(
          texto,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
      ],
    ),
  ),
);

InputDecoration _decoracion(String hint) => InputDecoration(
  filled: true,
  fillColor: AppColors.fondoCampo,
  hintText: hint,
  hintStyle: GoogleFonts.poppins(fontSize: 13),
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  ),
);

Widget _botonAzul({
  required String texto,
  required IconData icono,
  required VoidCallback? onPressed,
  bool cargando = false,
}) => SizedBox(
  width: double.infinity,
  height: 46,
  child: ElevatedButton.icon(
    onPressed: cargando ? null : onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.azulClaro,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    icon: cargando
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icono),
    label: Text(texto, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
  ),
);

// ---------------------------------------------------------------------------
// Pantalla principal con 2 pestañas
// ---------------------------------------------------------------------------

class Gestioncontable extends StatelessWidget {
  const Gestioncontable({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Barranavegacioninferior(
          botones: [
            BotonNav(
              icon: Icons.arrow_back,
              size: 26,
              onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
            ),
          ],
        ),
        body: Fondo(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 4),
                  child: Text(
                    'Megatech 2',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Gestión contable',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1BC2F0),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TabBar(
                  indicatorColor: AppColors.azulClaro,
                  labelColor: AppColors.azulClaro,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Reporte'),
                    Tab(text: 'Ventas'),
                  ],
                ),
                const Expanded(
                  child: TabBarView(children: [_TabReporte(), _TabVentas()]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pestaña 1: Reporte con filtros + descarga a Excel
// ---------------------------------------------------------------------------

class _TabReporte extends StatefulWidget {
  const _TabReporte();

  @override
  State<_TabReporte> createState() => _TabReporteState();
}

class _TabReporteState extends State<_TabReporte>
    with AutomaticKeepAliveClientMixin {
  final _service = ContableService();
  final _filtros = FiltrosReporte();

  List<OpcionFiltro> _vendedores = [];
  List<OpcionFiltro> _categorias = [];
  List<OpcionFiltro> _subcategorias = [];

  ReporteVentas? _reporte;
  bool _cargando = false;
  bool _descargando = false;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _cargarOpciones();
    _generar(); // muestra el reporte de "hoy" al entrar
  }

  Future<void> _cargarOpciones() async {
    try {
      final r = await Future.wait([
        _service.obtenerVendedores(),
        _service.obtenerCategorias(),
        _service.obtenerSubcategorias(),
      ]);
      if (!mounted) return;
      setState(() {
        _vendedores = r[0];
        _categorias = r[1];
        _subcategorias = r[2];
      });
    } catch (_) {
      // Si falla, los filtros quedan solo con "Todos"; el reporte sigue funcionando.
    }
  }

  bool _rangoValido() {
    if (_filtros.periodo != 'rango') return true;
    if (_filtros.inicio == null || _filtros.fin == null) {
      _aviso(context, 'Elige la fecha de inicio y la de fin', error: true);
      return false;
    }
    if (_filtros.fin!.isBefore(_filtros.inicio!)) {
      _aviso(
        context,
        'La fecha fin no puede ser menor que la de inicio',
        error: true,
      );
      return false;
    }
    return true;
  }

  Future<void> _generar() async {
    if (!_rangoValido()) return;
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final r = await _service.obtenerReporte(_filtros);
      if (!mounted) return;
      setState(() => _reporte = r);
    } on ContableException catch (e) {
      if (mounted) setState(() => _error = e.mensaje);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _descargarExcel() async {
    if (!_rangoValido()) return;
    if (kIsWeb) {
      _aviso(
        context,
        'La descarga de Excel está disponible en la app móvil/escritorio',
        error: true,
      );
      return;
    }
    setState(() => _descargando = true);
    try {
      final bytes = await _service.descargarExcel(_filtros);
      final dir = await getTemporaryDirectory();
      final nombre =
          'reporte_ventas_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final archivo = File('${dir.path}/$nombre');
      await archivo.writeAsBytes(bytes, flush: true);

      final res = await OpenFilex.open(archivo.path);
      if (res.type != ResultType.done && mounted) {
        _aviso(
          context,
          'Excel guardado, pero no hay una app para abrirlo (instala Excel o Google Sheets).',
          error: true,
        );
      }
    } on ContableException catch (e) {
      if (mounted) _aviso(context, e.mensaje, error: true);
    } catch (_) {
      if (mounted)
        _aviso(context, 'No se pudo guardar el archivo', error: true);
    } finally {
      if (mounted) setState(() => _descargando = false);
    }
  }

  Future<void> _elegirFecha(bool esInicio) async {
    final hoy = DateTime.now();
    final f = await showDatePicker(
      context: context,
      initialDate: (esInicio ? _filtros.inicio : _filtros.fin) ?? hoy,
      firstDate: DateTime(2020),
      lastDate: DateTime(hoy.year + 1),
    );
    if (f == null) return;
    setState(() => esInicio ? _filtros.inicio = f : _filtros.fin = f);
  }

  // ---------- widgets ----------

  Widget _chipPeriodo(String texto, String valor) {
    final activo = _filtros.periodo == valor;
    return ChoiceChip(
      label: Text(texto, style: GoogleFonts.poppins(fontSize: 12)),
      selected: activo,
      selectedColor: AppColors.azulClaro,
      backgroundColor: AppColors.fondoTarjeta,
      labelStyle: TextStyle(color: activo ? Colors.black : Colors.white),
      onSelected: (_) => setState(() => _filtros.periodo = valor),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? valor,
    required List<OpcionFiltro> opciones,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String?>(
      // ignore: deprecated_member_use
      value: valor,
      isExpanded: true,
      decoration: _decoracion(hint),
      items: [
        DropdownMenuItem<String?>(
          value: null,
          child: Text('$hint: todos', style: GoogleFonts.poppins(fontSize: 13)),
        ),
        ...opciones.map(
          (o) => DropdownMenuItem<String?>(
            value: o.id,
            child: Text(
              o.nombre,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }

  Widget _fechaBoton(String etiqueta, DateTime? fecha, bool esInicio) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () => _elegirFecha(esInicio),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: AppColors.azulClaro),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.calendar_today, size: 16),
        label: Text(
          fecha == null ? etiqueta : fechaIso(fecha),
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ),
    );
  }

  Widget _datoResumen(String titulo, String valor, IconData icono) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordeTarjeta),
      ),
      child: Row(
        children: [
          Icon(icono, color: AppColors.azulClaro),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    valor,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Las subcategorías se limitan a la categoría elegida
    final subs = _filtros.idCategoria == null
        ? _subcategorias
        : _subcategorias
              .where((s) => s.idPadre == _filtros.idCategoria)
              .toList();

    final r = _reporte;

    return RefreshIndicator(
      color: AppColors.azulClaro,
      onRefresh: _generar,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Wrap(
            spacing: 8,
            children: [
              _chipPeriodo('Hoy', 'hoy'),
              _chipPeriodo('Semana', 'semana'),
              _chipPeriodo('Mes', 'mes'),
              _chipPeriodo('Rango', 'rango'),
            ],
          ),
          if (_filtros.periodo == 'rango') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                _fechaBoton('Desde', _filtros.inicio, true),
                const SizedBox(width: 10),
                _fechaBoton('Hasta', _filtros.fin, false),
              ],
            ),
          ],
          const SizedBox(height: 12),
          _dropdown(
            hint: 'Vendedor',
            valor: _filtros.idVendedor,
            opciones: _vendedores,
            onChanged: (v) => setState(() => _filtros.idVendedor = v),
          ),
          const SizedBox(height: 10),
          _dropdown(
            hint: 'Categoría',
            valor: _filtros.idCategoria,
            opciones: _categorias,
            onChanged: (v) => setState(() {
              _filtros.idCategoria = v;
              _filtros.idSubcategoria = null; // la subcategoría ya no aplica
            }),
          ),
          const SizedBox(height: 10),
          _dropdown(
            hint: 'Subcategoría',
            valor: _filtros.idSubcategoria,
            opciones: subs,
            onChanged: (v) => setState(() => _filtros.idSubcategoria = v),
          ),
          const SizedBox(height: 14),
          _botonAzul(
            texto: 'Generar reporte',
            icono: Icons.bar_chart_rounded,
            cargando: _cargando,
            onPressed: _generar,
          ),
          const SizedBox(height: 10),
          _botonAzul(
            texto: 'Descargar Excel',
            icono: Icons.download_rounded,
            cargando: _descargando,
            onPressed: _descargarExcel,
          ),
          const SizedBox(height: 18),
          if (_cargando && r == null)
            const Center(
              child: CircularProgressIndicator(color: AppColors.azulClaro),
            )
          else if (_error != null)
            _mensajeVacio(Icons.wifi_off_rounded, _error!)
          else if (r != null) ...[
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.3,
              children: [
                _datoResumen(
                  'Total vendido',
                  moneda(r.resumen.totalVendido),
                  Icons.attach_money_rounded,
                ),
                _datoResumen(
                  'Ventas',
                  '${r.resumen.cantidadVentas}',
                  Icons.receipt_long_rounded,
                ),
                _datoResumen(
                  'Unidades',
                  '${r.resumen.unidadesVendidas}',
                  Icons.inventory_2_outlined,
                ),
                _datoResumen(
                  'Líneas de detalle',
                  '${r.resumen.cantidadDetalles}',
                  Icons.list_alt_rounded,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (r.ventas.isEmpty)
              _mensajeVacio(
                Icons.search_off_rounded,
                'No hay ventas con estos filtros',
              )
            else
              for (final v in r.ventas)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TarjetaVentaContable(venta: v),
                ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pestaña 2: Ventas (todas / por cédula de cliente / por cédula de vendedor)
// ---------------------------------------------------------------------------

class _TabVentas extends StatefulWidget {
  const _TabVentas();

  @override
  State<_TabVentas> createState() => _TabVentasState();
}

class _TabVentasState extends State<_TabVentas>
    with AutomaticKeepAliveClientMixin {
  final _service = ContableService();
  final _cedulaCtrl = TextEditingController();

  int _modo = 0; // 0 = todas, 1 = cliente, 2 = vendedor
  String _titulo = 'Todas las ventas';
  List<VentaContable> _ventas = [];
  bool _cargando = false;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    final cedula = _cedulaCtrl.text.trim();
    if (_modo != 0 && cedula.isEmpty) {
      _aviso(context, 'Escribe una cédula para buscar', error: true);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      if (_modo == 0) {
        final v = await _service.listarVentas();
        _titulo = 'Todas las ventas';
        _ventas = v;
      } else {
        final b = _modo == 1
            ? await _service.comprasPorCedula(cedula)
            : await _service.ventasPorCedulaVendedor(cedula);
        _titulo = b.titulo;
        _ventas = b.ventas;
      }
    } on ContableException catch (e) {
      _error = e.mensaje;
      _ventas = [];
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _eliminar(VentaContable v) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.fondoTarjeta,
        title: Text(
          'Eliminar venta #${v.id}',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          'Se borrará la venta y el stock de sus productos se devolverá al inventario. '
          'Esta acción no se puede deshacer.',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _service.eliminarVenta(v.id);
      if (!mounted) return;
      setState(() => _ventas.removeWhere((x) => x.id == v.id));
      _aviso(context, 'Venta eliminada y stock devuelto');
    } on ContableException catch (e) {
      if (mounted) _aviso(context, e.mensaje, error: true);
    }
  }

  Widget _chipModo(String texto, int valor) {
    final activo = _modo == valor;
    return ChoiceChip(
      label: Text(texto, style: GoogleFonts.poppins(fontSize: 12)),
      selected: activo,
      selectedColor: AppColors.azulClaro,
      backgroundColor: AppColors.fondoTarjeta,
      labelStyle: TextStyle(color: activo ? Colors.black : Colors.white),
      onSelected: (_) {
        setState(() => _modo = valor);
        if (valor == 0) _buscar(); // "Todas" no necesita cédula
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final total = _ventas.fold<double>(0, (s, v) => s + v.total);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            children: [
              Wrap(
                spacing: 8,
                children: [
                  _chipModo('Todas', 0),
                  _chipModo('Por cliente', 1),
                  _chipModo('Por vendedor', 2),
                ],
              ),
              if (_modo != 0) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cedulaCtrl,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => _buscar(),
                        decoration: _decoracion('Cédula'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: _buscar,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.azulClaro,
                      ),
                      icon: const Icon(Icons.search, color: Colors.black),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Row(
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
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _cargando
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.azulClaro),
                )
              : _error != null
              ? _mensajeVacio(Icons.error_outline_rounded, _error!)
              : _ventas.isEmpty
              ? _mensajeVacio(
                  Icons.receipt_long_outlined,
                  'No hay ventas para mostrar',
                )
              : RefreshIndicator(
                  color: AppColors.azulClaro,
                  onRefresh: _buscar,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    itemCount: _ventas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => TarjetaVentaContable(
                      venta: _ventas[i],
                      onEliminar: () => _eliminar(_ventas[i]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
