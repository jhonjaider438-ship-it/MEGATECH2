import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'apiuser.dart';

class DashboardService {
  Future<Map<String, String>> _headersConToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {...ApiConfig.headers, 'Authorization': 'Bearer $token'};
  }

  Future<int> obtenerPedidosPorEntregar() async {
    final url = Uri.parse('${ApiConfig.rootUrl}/pedidos/contar/por-entregar');
    final response = await http.get(url, headers: await _headersConToken());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['total'] ?? 0;
    } else {
      throw Exception('Error al obtener pedidos por entregar');
    }
  }

  Future<int> obtenerProductosBajoStock() async {
    final url = Uri.parse('${ApiConfig.rootUrl}/productos/bajo-stock');
    final response = await http.get(url, headers: await _headersConToken());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['total'] ?? 0;
    } else {
      throw Exception('Error al obtener productos con bajo stock');
    }
  }
}
