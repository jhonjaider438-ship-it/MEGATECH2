import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'apiuser.dart';

class MensajeChat {
  final String emisor; 
  final String mensaje;

  MensajeChat({required this.emisor, required this.mensaje});

  factory MensajeChat.fromJson(Map<String, dynamic> json) {
    return MensajeChat(
      emisor: json['emisor'] ?? 'bot',
      mensaje: json['mensaje'] ?? '',
    );
  }
}

class IaAdminService {
  Future<Map<String, String>> _headersConToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {...ApiConfig.headers, 'Authorization': 'Bearer $token'};
  }

  /// Envia un mensaje a la IA admin (ruta protegida Admin/Empleado)
  /// y devuelve la respuesta del bot junto con el sesionId.
  Future<Map<String, dynamic>> enviarMensaje({
    required String mensaje,
    String? sesionId,
  }) async {
    final url = Uri.parse('${ApiConfig.rootUrl}/ialaboral');

    final response = await http.post(
      url,
      headers: await _headersConToken(),
      body: jsonEncode({
        'mensaje': mensaje,
        if (sesionId != null) 'sesionId': sesionId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
      // -> { respuesta: "...", sesionId: "..." }
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error al hablar con la IA');
    }
  }

  /// Trae el historial guardado de una sesion (si el admin vuelve a
  /// abrir el chat despues de haberlo cerrado).
  Future<List<MensajeChat>> obtenerHistorial(String sesionId) async {
    final url = Uri.parse('${ApiConfig.rootUrl}/ialaboral/historial/$sesionId');

    final response = await http.get(url, headers: await _headersConToken());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List historial = data['historial'] ?? [];
      return historial.map((e) => MensajeChat.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener el historial');
    }
  }
}