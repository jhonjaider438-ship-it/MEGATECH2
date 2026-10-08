import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class Tecno extends StatelessWidget {
  const Tecno({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Tecno',
      subcategoria: 'Tecno',
    );
  }
}
