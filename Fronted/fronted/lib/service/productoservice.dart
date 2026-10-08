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

  /// Rol del usuario ('Admin', 'Empleado', 'Cliente') leído del token JWT que
  /// guardó el login. Si no hay sesión (invitado) devuelve null.
  Future<String?> rolActual() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final partes = token.split('.');
    if (partes.length != 3) return null;
    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(partes[1])),
      );
      return (jsonDecode(payload) as Map<String, dynamic>)['rol']?.toString();
    } catch (_) {
      return null;
    }
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

  /// "Cabezotes TC" -> "cabezotestc" (sin tildes, mayúsculas ni símbolos).
  static String _normalizar(String texto) {
    const conTilde = 'áàäâéèëêíìïîóòöôúùüûñ';
    const sinTilde = 'aaaaeeeeiiiioooouuuun';
    var t = texto.toLowerCase();
    for (var i = 0; i < conTilde.length; i++) {
      t = t.replaceAll(conTilde[i], sinTilde[i]);
    }
    return t.replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static bool _coincide(String deProducto, String buscada) {
    final a = _normalizar(deProducto);
    final b = _normalizar(buscada);
    if (a.isEmpty || b.isEmpty) return false;
    if (a == b) return true;
    return a.length >= 4 && b.length >= 4 && (a.contains(b) || b.contains(a));
  }

  /// GET /productos (ruta pública) y se queda con los de una subcategoría.
  /// [soloDisponibles] oculta los productos sin stock.
  Future<List<Producto>> obtenerPorSubcategoria(
    String subcategoria, {
    bool soloDisponibles = true,
  }) async {
    final url = Uri.parse('${ApiConfig.rootUrl}/productos');
    final response = await http
        .get(url, headers: ApiConfig.headers)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Error al obtener los productos');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((e) => Producto.fromJson(e as Map<String, dynamic>))
        .where((p) => _coincide(p.subcategoria ?? '', subcategoria))
        .where((p) => !soloDisponibles || p.stock > 0)
        .toList();
  }
}