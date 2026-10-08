import 'dart:async';
import 'dart:convert';
import 'package:fronted/model/productos.dart';
import 'package:fronted/model/ventas.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'apiuser.dart';

class VentaException implements Exception {
  final String mensaje;
  const VentaException(this.mensaje);

  @override
  String toString() => mensaje;
}

class VentasService {
  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<Map<String, String>> _headersConToken() async {
    return {...ApiConfig.headers, 'Authorization': 'Bearer ${await _token()}'};
  }

  String _mensajeDe(http.Response r, String porDefecto) {
    try {
      final data = jsonDecode(r.body);
      if (data is Map) {
        return (data['error'] ?? data['mensaje'] ?? data['message'] ?? porDefecto)
            .toString();
      }
    } catch (_) {}
    return porDefecto;
  }

  /// El id del vendedor sale del token JWT del usuario que inició sesión
  /// (el backend lo firma con { id, correo, rol }).
  Future<dynamic> idVendedorActual() async {
    final token = await _token();
    final partes = token.split('.');
    if (partes.length != 3) return null;
    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(partes[1])),
      );
      return (jsonDecode(payload) as Map<String, dynamic>)['id'];
    } catch (_) {
      return null;
    }
  }

  /// GET /productos (ruta pública) -> catálogo con precio y stock.
  Future<List<Producto>> obtenerProductos() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.rootUrl}/productos'),
            headers: ApiConfig.headers,
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => Producto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw VentaException(_mensajeDe(response, 'Error al cargar productos'));
    } on VentaException {
      rethrow;
    } catch (_) {
      throw const VentaException('No se pudo conectar con el servidor');
    }
  }

  /// POST /ventas
  Future<VentaRegistrada> registrarVenta({
    required String cedulaCliente,
    required dynamic idVendedor,
    required List<ItemVenta> items,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.rootUrl}/ventas'),
            headers: await _headersConToken(),
            body: jsonEncode({
              'cedula_cliente': cedulaCliente,
              'id_vendedor': idVendedor,
              'productos': items
                  .map((i) => {
                        'id_producto': i.producto!.id,
                        'cantidad': i.cantidad,
                      })
                  .toList(),
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return VentaRegistrada.fromJson(jsonDecode(response.body));
      }
      if (response.statusCode == 401) {
        throw const VentaException(
          'Tu sesión expiró. Inicia sesión de nuevo para continuar.',
        );
      }
      throw VentaException(_mensajeDe(response, 'No se pudo registrar la venta'));
    } on VentaException {
      rethrow;
    } on TimeoutException {
      throw const VentaException(
        'El servidor tardó demasiado. Revisa en ventas si se registró antes de reintentar.',
      );
    } catch (_) {
      throw const VentaException('No se pudo conectar con el servidor');
    }
  }
}