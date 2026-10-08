import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:fronted/model/gestioncontable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'apiuser.dart';

class ContableException implements Exception {
  final String mensaje;
  const ContableException(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Todas las llamadas del backend que usa la Gestión contable (solo Admin).
class ContableService {
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {...ApiConfig.headers, 'Authorization': 'Bearer $token'};
  }

  String _mensajeDe(http.Response r, String porDefecto) {
    try {
      final data = jsonDecode(r.body);
      if (data is Map) {
        return (data['error'] ??
                data['mensaje'] ??
                data['message'] ??
                porDefecto)
            .toString();
      }
    } catch (_) {}
    return porDefecto;
  }

  /// GET genérico con manejo de errores común.
  Future<http.Response> _get(String ruta, {Map<String, String>? query}) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.rootUrl}$ruta',
      ).replace(queryParameters: query);
      final r = await http
          .get(uri, headers: await _headers())
          .timeout(const Duration(seconds: 30));
      if (r.statusCode == 401 || r.statusCode == 403) {
        throw const ContableException(
          'Tu sesión expiró o no tienes permiso. Inicia sesión de nuevo.',
        );
      }
      return r;
    } on ContableException {
      rethrow;
    } on TimeoutException {
      throw const ContableException('El servidor tardó demasiado en responder');
    } catch (_) {
      throw const ContableException('No se pudo conectar con el servidor');
    }
  }

  // ---------- Reporte ----------

  /// GET /ventas/reporte
  Future<ReporteVentas> obtenerReporte(FiltrosReporte f) async {
    final r = await _get('/ventas/reporte', query: f.toQuery());
    if (r.statusCode == 200) {
      return ReporteVentas.fromJson(jsonDecode(r.body));
    }
    throw ContableException(_mensajeDe(r, 'No se pudo generar el reporte'));
  }

  /// GET /ventas/reporte/excel -> bytes del archivo .xlsx
  Future<Uint8List> descargarExcel(FiltrosReporte f) async {
    final r = await _get('/ventas/reporte/excel', query: f.toQuery());
    if (r.statusCode == 200) return r.bodyBytes;
    throw ContableException(_mensajeDe(r, 'No se pudo generar el Excel'));
  }

  // ---------- Listados de ventas ----------

  /// GET /ventas
  Future<List<VentaContable>> listarVentas() async {
    final r = await _get('/ventas');
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body);
      return (data['ventas'] as List? ?? [])
          .map((e) => VentaContable.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw ContableException(_mensajeDe(r, 'No se pudieron cargar las ventas'));
  }

  /// GET /ventas/cedula/:cedula  (compras de un cliente)
  Future<BusquedaVentas> comprasPorCedula(String cedula) async {
    final r = await _get('/ventas/cedula/$cedula');
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body);
      final c = data['cliente'] ?? {};
      return BusquedaVentas(
        titulo: 'Compras de ${c['nombre'] ?? ''} ${c['apellido'] ?? ''}'.trim(),
        ventas: (data['compras'] as List? ?? [])
            .map((e) => VentaContable.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
    throw ContableException(_mensajeDe(r, 'No se encontró el cliente'));
  }

  /// GET /ventas/vendedor/cedula/:cedula  (ventas de un vendedor)
  Future<BusquedaVentas> ventasPorCedulaVendedor(String cedula) async {
    final r = await _get('/ventas/vendedor/cedula/$cedula');
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body);
      final v = data['vendedor'] ?? {};
      return BusquedaVentas(
        titulo: 'Ventas de ${v['nombre'] ?? ''} ${v['apellido'] ?? ''}'.trim(),
        ventas: (data['ventas'] as List? ?? [])
            .map((e) => VentaContable.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
    throw ContableException(_mensajeDe(r, 'No se encontró el vendedor'));
  }

  /// DELETE /ventas/:id  (devuelve el stock automáticamente)
  Future<void> eliminarVenta(int id) async {
    try {
      final r = await http
          .delete(
            Uri.parse('${ApiConfig.rootUrl}/ventas/$id'),
            headers: await _headers(),
          )
          .timeout(const Duration(seconds: 30));
      if (r.statusCode == 200) return;
      throw ContableException(_mensajeDe(r, 'No se pudo eliminar la venta'));
    } on ContableException {
      rethrow;
    } catch (_) {
      throw const ContableException('No se pudo conectar con el servidor');
    }
  }

  // ---------- Datos para los filtros ----------

  /// GET /usuario -> solo Admin y Empleado (los que pueden vender)
  Future<List<OpcionFiltro>> obtenerVendedores() async {
    final r = await _get('/usuario');
    if (r.statusCode != 200) return [];
    final lista = (jsonDecode(r.body)['usuarios'] as List? ?? []);
    return lista
        .where((u) => u['rol'] == 'Admin' || u['rol'] == 'Empleado')
        .map(
          (u) => OpcionFiltro(
            id: u['id'].toString(),
            nombre: '${u['nombre'] ?? ''} ${u['apellido'] ?? ''}'.trim(),
          ),
        )
        .toList();
  }

  /// GET /categorias
  Future<List<OpcionFiltro>> obtenerCategorias() async {
    final r = await _get('/categorias');
    if (r.statusCode != 200) return [];
    return (jsonDecode(r.body) as List)
        .map(
          (c) => OpcionFiltro(
            id: c['id'].toString(),
            nombre: (c['nombre_categoria'] ?? '').toString(),
          ),
        )
        .toList();
  }

  /// GET /subcategorias
  Future<List<OpcionFiltro>> obtenerSubcategorias() async {
    final r = await _get('/subcategorias');
    if (r.statusCode != 200) return [];
    return (jsonDecode(r.body) as List)
        .map(
          (s) => OpcionFiltro(
            id: s['id'].toString(),
            nombre: (s['nombre'] ?? '').toString(),
            idPadre: s['id_categoria']?.toString(),
          ),
        )
        .toList();
  }
}
