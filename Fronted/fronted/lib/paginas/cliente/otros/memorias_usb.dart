import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class MemoriasUsb extends StatelessWidget {
  const MemoriasUsb({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Memorias USB',
      subcategoria: 'Memorias USB',
    );
  }
}
