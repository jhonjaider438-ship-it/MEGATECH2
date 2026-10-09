import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/gestioncontable.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/abrirexcel.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/botonaccion.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/filtrosreporte.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/resumenreporte.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/targetaventacontable.dart';
import 'package:fronted/paginas/admin/widets.dart/listaasincrona.dart';
import 'package:fronted/paginas/admin/widets.dart/ventas/mensajesnack.dart';
import 'package:fronted/service/gestioncontable.dart';

/// Pestaña "Reporte": filtros + resumen + ventas + descarga a Excel.
class TabReporte extends StatefulWidget {
  const TabReporte({super.key});

  @override
  State<TabReporte> createState() => _TabReporteState();
}

class _TabReporteState extends State<TabReporte>
    with AutomaticKeepAliveClientMixin {
  final _service = ContableService();
  final _filtros = FiltrosReporte();

  List<OpcionFiltro> _vendedores = [], _categorias = [], _subcategorias = [];
  ReporteVentas? _reporte;
  bool _cargando = false, _descargando = false;
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

  /// Mensaje de error del rango de fechas, o null si es válido.
  String? _errorRango() {
    if (_filtros.periodo != 'rango') return null;
    final (i, f) = (_filtros.inicio, _filtros.fin);
    if (i == null || f == null) return 'Elige la fecha de inicio y la de fin';
    if (f.isBefore(i))
      return 'La fecha fin no puede ser menor que la de inicio';
    return null;
  }

  Future<void> _generar() async {
    final error = _errorRango();
    if (error != null) return mostrarError(context, error);

    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final r = await _service.obtenerReporte(_filtros);
      if (mounted) setState(() => _reporte = r);
    } on ContableException catch (e) {
      if (mounted) setState(() => _error = e.mensaje);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _descargarExcel() async {
    final error = _errorRango();
    if (error != null) return mostrarError(context, error);

    setState(() => _descargando = true);
    try {
      final bytes = await _service.descargarExcel(_filtros);
      if (mounted) await guardarYAbrirExcel(context, bytes);
    } on ContableException catch (e) {
      if (mounted) mostrarError(context, e.mensaje);
    } finally {
      if (mounted) setState(() => _descargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final r = _reporte;

    return RefreshIndicator(
      color: AppColors.azulClaro,
      onRefresh: _generar,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          PanelFiltrosReporte(
            filtros: _filtros,
            vendedores: _vendedores,
            categorias: _categorias,
            subcategorias: _subcategorias,
            onCambio: () => setState(() {}),
          ),
          const SizedBox(height: 14),
          BotonAccion(
            texto: 'Generar reporte',
            icono: Icons.bar_chart_rounded,
            cargando: _cargando,
            onTap: _generar,
          ),
          const SizedBox(height: 10),
          BotonAccion(
            texto: 'Descargar Excel',
            icono: Icons.download_rounded,
            cargando: _descargando,
            onTap: _descargarExcel,
          ),
          const SizedBox(height: 18),
          if (_cargando && r == null)
            const Center(
              child: CircularProgressIndicator(color: AppColors.azulClaro),
            )
          else if (_error != null)
            MensajeEstado(
              icono: Icons.wifi_off_rounded,
              texto: _error!,
              onReintentar: _generar,
            )
          else if (r != null) ...[
            ResumenReporteGrid(resumen: r.resumen),
            const SizedBox(height: 16),
            if (r.ventas.isEmpty)
              const MensajeEstado(
                icono: Icons.search_off_rounded,
                texto: 'No hay ventas con estos filtros',
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
