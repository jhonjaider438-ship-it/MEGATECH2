import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class Arrozeras extends StatelessWidget {
  const Arrozeras({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Arrozeras',
      subcategoria: 'Arrozeras',
    );
  }
}
