import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/auth';
    }
    //evaluaremos para dispositivos moviles
    if (Platform.isAndroid) {
      // emulador para androit
      return 'http://10.4.8.167:3000/auth';
    } else if (Platform.isIOS) {
      // emulador para ios
      return 'http://localhost:3000/auth';
    } else {
      // para mac wundous linux
      return 'http://localhost:3000/auth';
    }
  }

  static const Map<String, String> headers = {
    'content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
