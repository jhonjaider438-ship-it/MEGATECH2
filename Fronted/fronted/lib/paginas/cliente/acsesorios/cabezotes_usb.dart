import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class CabezotesUsb extends StatelessWidget {
  const CabezotesUsb({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Cabezotes USB',
      subcategoria: 'Cabezotes USB',
    );
  }
}
