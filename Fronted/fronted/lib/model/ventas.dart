import 'package:fronted/model/productos.dart';

/// Una línea de la venta (una tarjeta en pantalla): producto + cantidad.
class ItemVenta {
  /// Identifica la tarjeta en la lista (no es el id del producto).
  final int uid;
  Producto? producto;
  int cantidad;

  ItemVenta({required this.uid, this.producto, this.cantidad = 1});

  /// Solo para mostrar en pantalla; el backend recalcula el valor real.
  double get subtotal => producto == null ? 0 : producto!.precio * cantidad;
}

/// Respuesta de POST /ventas.
class VentaRegistrada {
  final int id;
  final double total;
  final String fecha;
  final int lineas;

  const VentaRegistrada({
    required this.id,
    required this.total,
    required this.fecha,
    required this.lineas,
  });

  factory VentaRegistrada.fromJson(Map<String, dynamic> json) {
    final venta = (json['venta'] ?? {}) as Map<String, dynamic>;
    final detalles = json['detalles'];
    return VentaRegistrada(
      id: int.tryParse(venta['id'].toString()) ?? 0,
      total: double.tryParse(venta['total'].toString()) ?? 0,
      fecha: (venta['fecha'] ?? '').toString(),
      lineas: detalles is List ? detalles.length : 0,
    );
  }
}