import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'apiuser.dart';
import 'ialaboral.dart' show MensajeChat;

// Re-exporta el modelo para que la pantalla pueda usar MensajeChat
// importando solo este archivo.
export 'ialaboral.dart' show MensajeChat;

class IaClienteService {
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      ...ApiConfig.headers,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Envía un mensaje a la IA del cliente.
  /// Devuelve: { respuesta: "...", sesionId: "..." }
  Future<Map<String, dynamic>> enviarMensaje({
    required String mensaje,
    String? sesionId,
  }) async {
    final url = Uri.parse('${ApiConfig.rootUrl}/iaclie'); // <-- ajusta tu ruta

    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'mensaje': mensaje,
        if (sesionId != null) 'sesionId': sesionId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error al hablar con la IA');
    }
  }

  /// Trae el historial guardado de una sesión.
  Future<List<MensajeChat>> obtenerHistorial(String sesionId) async {
    final url = Uri.parse(
      '${ApiConfig.rootUrl}/iacliente/historial/$sesionId', // <-- ajusta tu ruta
    );

    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List historial = data['historial'] ?? [];
      return historial.map((e) => MensajeChat.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener el historial');
    }
  }
}
