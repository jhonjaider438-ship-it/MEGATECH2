import 'dart:convert';
import 'package:fronted/model/user.dart';
import 'package:http/http.dart' as http;
import 'apiuser.dart';

class Userservice {
  // Peticion POST para iniciar sesion
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

  // peticion para registrar un nuevo usuario
  // Devuelve el mapa completo {message, emailEnviado, usuario} que manda
  // el backend, para que quien lo llame sepa si el correo se envió o no.
  Future<Map<String, dynamic>> registrar(usermodel usuario) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/registro');

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode(usuario.toJson()),
      );
      final contentType = response.headers['content-type'] ?? '';

      // si el server responde 201 o 200
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        if (contentType.contains('application/json')) {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          final String errorMessage =
              errorData['error'] ??
              errorData['message'] ??
              'Error desconocido';
          throw Exception(errorMessage);
        } else {
          throw Exception('Error al registrar usuario: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // peticion para verificar el correo con el codigo de 6 digitos
  Future<Map<String, dynamic>> verificarCuenta(
    String correo,
    String codigo,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/verify-account');

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode({'correo': correo, 'codigo': codigo}),
      );
      final contentType = response.headers['content-type'] ?? '';

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        if (contentType.contains('application/json')) {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          throw Exception(
            errorData['error'] ??
                errorData['message'] ??
                'Código de verificación incorrecto',
          );
        } else {
          throw Exception(
            'Servidor no disponible (Código ${response.statusCode})',
          );
        }
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // peticion para reenviar el codigo de verificacion
  Future<Map<String, dynamic>> reenviarCodigo(String correo) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/reenviar-codigo');

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode({'correo': correo}),
      );
      final contentType = response.headers['content-type'] ?? '';

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        if (contentType.contains('application/json')) {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          throw Exception(
            errorData['error'] ??
                errorData['message'] ??
                'No se pudo reenviar el código',
          );
        } else {
          throw Exception(
            'Servidor no disponible (Código ${response.statusCode})',
          );
        }
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}