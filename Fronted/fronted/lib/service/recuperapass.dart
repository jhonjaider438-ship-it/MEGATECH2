import 'dart:convert';
import 'package:http/http.dart' as http;

import 'apiuser.dart';
import '../model/recuperapass.dart';
import '../model/codigoverificacion.dart';

class RecuperarService {
  // ==========================================
  // ENVIAR CÓDIGO
  // ==========================================

  Future<Map<String, dynamic>> enviarCodigo(RecuperarModel recuperar) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/enviarcodigo');

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode(recuperar.toJson()),
      );

      print('STATUS ENVIAR CÓDIGO: ${response.statusCode}');
      print('RESPUESTA ENVIAR CÓDIGO: ${response.body}');

      final contentType = response.headers['content-type'] ?? '';

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      if (contentType.contains('application/json')) {
        final errorData = jsonDecode(response.body);

        throw Exception(
          errorData['error'] ??
              errorData['mensaje'] ??
              errorData['message'] ??
              'No se pudo enviar el código',
        );
      }

      throw Exception(
        'Servidor no disponible '
        '(Código ${response.statusCode})',
      );
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ==========================================
  // VERIFICAR CÓDIGO Y CAMBIAR CONTRASEÑA
  // ==========================================

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

      print('STATUS VERIFICAR: ${response.statusCode}');
      print('RESPUESTA VERIFICAR: ${response.body}');

      final contentType = response.headers['content-type'] ?? '';

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      }

      if (contentType.contains('application/json')) {
        final errorData = jsonDecode(response.body);

        throw Exception(
          errorData['error'] ??
              errorData['mensaje'] ??
              errorData['message'] ??
              'Código incorrecto',
        );
      }

      throw Exception(
        'Servidor no disponible '
        '(Código ${response.statusCode})',
      );
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
