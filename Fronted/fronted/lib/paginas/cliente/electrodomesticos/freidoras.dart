import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class Freidoras extends StatelessWidget {
  const Freidoras({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Freidoras de aire',
      subcategoria: 'Freidoras de aire',
    );
  }
}
