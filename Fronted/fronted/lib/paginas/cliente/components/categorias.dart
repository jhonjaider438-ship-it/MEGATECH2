import 'package:flutter/material.dart';
import 'package:fronted/paginas/cliente/acsesorios/forros.dart';
import 'package:fronted/paginas/cliente/celulares/celulares_redmi.dart';
import 'package:fronted/paginas/cliente/components/botonproductos.dart';
import 'package:fronted/paginas/cliente/electrodomesticos/ollaspresion.dart';
import 'package:fronted/paginas/cliente/otros/bolsos.dart';

class CategoriasProductos extends StatelessWidget {
  const CategoriasProductos({super.key});

  void _ir(BuildContext context, Widget pantalla) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Botonproductos(
          icono: Icons.smartphone,
          texto: 'Celulares',
          onTap: () => _ir(context, const Celularesredmi()),
        ),
        const SizedBox(height: 15),
        Botonproductos(
          icono: Icons.bolt,
          texto: 'Acsesorios',
          onTap: () => _ir(context, const Forros()),
        ),
        const SizedBox(height: 15),
        Botonproductos(
          icono: Icons.kitchen,
          texto: 'Electrodomesticos',
          onTap: () => _ir(context, const Ollaspresion()),
        ),
        const SizedBox(height: 15),
        Botonproductos(
          icono: Icons.category,
          texto: 'Otros',
          onTap: () => _ir(context, const Bolsos()),
        ),
      ],
    );
  }
}
