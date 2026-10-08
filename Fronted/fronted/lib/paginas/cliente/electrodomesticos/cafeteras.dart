import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class Cafeteras extends StatelessWidget {
  const Cafeteras({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Cafeteras',
      subcategoria: 'Cafeteras',
    );
  }
}
