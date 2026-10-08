import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class Licuadoras extends StatelessWidget {
  const Licuadoras({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Licuadoras',
      subcategoria: 'Licuadoras',
    );
  }
}
