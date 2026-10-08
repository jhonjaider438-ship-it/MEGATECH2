import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class Bolsos extends StatelessWidget {
  const Bolsos({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Bolsos',
      subcategoria: 'Bolsos',
    );
  }
}
