import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apiuser.dart';
import '../model/recuperapass.dart';
import '../model/codigoverificacion.dart';

class RecuperarService {
  // Petición POST para enviar código de recuperación
  Future<Map<String, dynamic>> enviarCodigo(RecuperarModel recuperar) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/enviarcodigo');

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode(recuperar.toJson()),
      );

      final contentType = response.headers['content-type'] ?? '';

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData;
      } else {
        if (contentType.contains('application/json')) {
          final Map<String, dynamic> errorData = jsonDecode(response.body);

          final String mensajeError =
              errorData['error'] ??
              errorData['mensaje'] ??
              errorData['message'] ??
              'No se pudo enviar el código';

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


// VERIFICAR CÓDIGO
Future<Map<String, dynamic>> verificarCodigo(
  VerificarCodigoModel verificar,
) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/verificarcodigo');

  try {
    final response = await http.post(
      url,
      headers: ApiConfig.headers,
      body: jsonEncode(verificar.toJson()),
    );

    final contentType = response.headers['content-type'] ?? '';

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      if (contentType.contains('application/json')) {
        final errorData = jsonDecode(response.body);

        throw Exception(
          errorData['error'] ??
              errorData['mensaje'] ??
              errorData['message'] ??
              'Código incorrecto',
        );
      } else {
        throw Exception(
          'Servidor no disponible '
          '(Código ${response.statusCode})',
        );
      }
    }
  } catch (e) {
    throw Exception(e.toString().replaceFirst('Exception: ', ''));
  }
}
}