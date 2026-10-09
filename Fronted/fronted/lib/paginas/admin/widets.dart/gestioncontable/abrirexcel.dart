import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fronted/paginas/admin/widets.dart/ventas/mensajesnack.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// Guarda los [bytes] como .xlsx temporal y lo abre con la app del dispositivo.
/// Muestra por sí sola los avisos de error. No funciona en web.
Future<void> guardarYAbrirExcel(BuildContext context, List<int> bytes) async {
  if (kIsWeb) {
    mostrarError(
      context,
      'La descarga de Excel está disponible en la app móvil/escritorio',
    );
    return;
  }
  try {
    final dir = await getTemporaryDirectory();
    final archivo = File(
      '${dir.path}/reporte_ventas_${DateTime.now().millisecondsSinceEpoch}.xlsx',
    );
    await archivo.writeAsBytes(bytes, flush: true);

    final res = await OpenFilex.open(archivo.path);
    if (res.type != ResultType.done && context.mounted) {
      mostrarError(
        context,
        'Excel guardado, pero no hay una app para abrirlo (instala Excel o Google Sheets).',
      );
    }
  } catch (_) {
    if (context.mounted) mostrarError(context, 'No se pudo guardar el archivo');
  }
}
