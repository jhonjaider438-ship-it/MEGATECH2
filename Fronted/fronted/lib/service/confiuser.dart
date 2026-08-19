import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apiuser.dart';

class userservice {
  // Peticion POST para iniciar sesion (NUEVO, dentro de la misma clase)
  Future<Map<String, dynamic>> loginUsuario(
    String correo,
    String contrasena,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode({'correo': correo, 'contraseña': contrasena}),
      );

      final contentType = response.headers['content-type'] ?? '';

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Devuelve el mapa completo con 'token' y 'usuario' tal como responde el backend
        return responseData;
      } else {
        if (contentType.contains('application/json')) {
          final Map<String, dynamic> errorData = jsonDecode(response.body);

          // El backend Express envia el mensaje en la clave 'error'
          final String mensajeError =
              errorData['error'] ??
              errorData['message'] ??
              'Credenciales incorrectas';

          throw Exception(mensajeError);
        } else {
          throw Exception(
            'Servidor no disponible o ruta no encontrada '
            '(Código ${response.statusCode})',
          );
        }
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
