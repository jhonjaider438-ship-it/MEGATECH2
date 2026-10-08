import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class Planchas extends StatelessWidget {
  const Planchas({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Planchas',
      subcategoria: 'Planchas',
    );
  }
}
