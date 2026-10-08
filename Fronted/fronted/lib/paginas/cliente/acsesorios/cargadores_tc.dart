import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class CargadoresTc extends StatelessWidget {
  const CargadoresTc({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Cargadores TC',
      subcategoria: 'Cargadores TC',
    );
  }
}
