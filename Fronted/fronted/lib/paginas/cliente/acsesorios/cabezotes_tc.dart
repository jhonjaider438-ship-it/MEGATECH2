import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/components/pantallaproductos.dart';

class CabezotesTc extends StatelessWidget {
  const CabezotesTc({super.key});

  @override
  Widget build(BuildContext context) {
    return const PantallaProductos(
      titulo: 'Cabezotes TC',
      subcategoria: 'Cabezotes TC',
    );
  }
}
