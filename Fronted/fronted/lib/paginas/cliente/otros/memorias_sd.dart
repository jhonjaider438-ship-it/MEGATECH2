import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class MemoriasSd extends StatelessWidget {
  const MemoriasSd({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Memorias SD',
      subcategoria: 'Memorias SD',
    );
  }
}
