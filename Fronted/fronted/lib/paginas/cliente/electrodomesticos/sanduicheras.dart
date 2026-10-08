import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class Sanduicheras extends StatelessWidget {
  const Sanduicheras({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Sandwichera',
      subcategoria: 'Sandwichera',
    );
  }
}
