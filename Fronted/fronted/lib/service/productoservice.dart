import 'dart:convert';
import 'package:fronted/model/productos.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'apiuser.dart';

class ProductosService {
  Future<Map<String, String>> _headersConToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {...ApiConfig.headers, 'Authorization': 'Bearer $token'};
  }

  /// Trae la lista de productos con bajo stock desde el backend.
  Future<List<Producto>> obtenerListaBajoStock() async {
    final url = Uri.parse('${ApiConfig.rootUrl}/productos/bajo-stock/lista');
    final response = await http.get(url, headers: await _headersConToken());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => Producto.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al obtener productos con bajo stock');
    }
  }
}
