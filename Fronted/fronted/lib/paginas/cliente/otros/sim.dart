import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class Sim extends StatelessWidget {
  const Sim({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Sim',
      subcategoria: 'Sim',
    );
  }
}
