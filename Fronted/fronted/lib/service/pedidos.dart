import 'dart:convert';
import 'package:fronted/model/pedidos.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'apiuser.dart';

/// Error al hablar con el backend de pedidos.
/// [aplicado] = true cuando el backend SÍ guardó el cambio de estado en la
/// base de datos pero falló algo posterior (por ejemplo, el envío del correo).
class PedidoException implements Exception {
  final String mensaje;
  final bool aplicado;

  const PedidoException(this.mensaje, {this.aplicado = false});

  @override
  String toString() => mensaje;
}

class PedidosService {
  Future<Map<String, String>> _headersConToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {...ApiConfig.headers, 'Authorization': 'Bearer $token'};
  }

  String _mensajeDe(http.Response r, String porDefecto) {
    try {
      final data = jsonDecode(r.body);
      if (data is Map) {
        return (data['mensaje'] ??
                data['error'] ??
                data['message'] ??
                porDefecto)
            .toString();
      }
    } catch (_) {}
    return porDefecto;
  }

  /// GET /pedidos/resumen -> pedidos con cliente, foto principal y artículos.
  Future<List<Pedido>> obtenerPedidos() async {
    final url = Uri.parse('${ApiConfig.rootUrl}/pedidos/resumen');
    final response = await http
        .get(url, headers: await _headersConToken())
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => Pedido.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw PedidoException(_mensajeDe(response, 'Error al obtener los pedidos'));
  }

  /// PUT /pedidos/actualizar/:id  -> cambia el estado en la base de datos.
  Future<void> cambiarEstado(int idPedido, String nuevoEstado) async {
    final url = Uri.parse('${ApiConfig.rootUrl}/pedidos/actualizar/$idPedido');
    final response = await http
        .put(
          url,
          headers: await _headersConToken(),
          body: jsonEncode({'estado': nuevoEstado}),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) return;

    final mensaje = _mensajeDe(response, 'No se pudo cambiar el estado');
    // El backend responde 500 con "El pedido se actualizó, pero ..." cuando el
    // estado ya quedó guardado y solo falló el correo al cliente.
    throw PedidoException(mensaje, aplicado: mensaje.contains('se actualizó'));
  }
}
