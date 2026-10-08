import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class CablesUsb extends StatelessWidget {
  const CablesUsb({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Cables USB',
      subcategoria: 'Cables USB',
    );
  }
}
