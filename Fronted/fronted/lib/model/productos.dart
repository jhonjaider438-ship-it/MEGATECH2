/// Producto tal como lo devuelve el backend (tabla "productos" de Supabase).
class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final String? foto;
  final String? subcategoria;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    this.foto,
    this.subcategoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nombre: (json['nombre'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      precio: double.tryParse(json['precio'].toString()) ?? 0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      foto: (json['foto'] == null || json['foto'].toString().isEmpty)
          ? null
          : json['foto'].toString(),
      subcategoria: json['subcategorias'] is Map
          ? json['subcategorias']['nombre']?.toString()
          : null,
    );
  }
}
