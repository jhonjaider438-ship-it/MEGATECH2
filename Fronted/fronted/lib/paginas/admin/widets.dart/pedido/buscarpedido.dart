import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fronted/paginas/cliente/components/barradebusqueda.dart';

/// Barra de búsqueda numérica con botón "X" para limpiar cuando hay búsqueda activa.
class BarraBusquedaCedula extends StatelessWidget {
  final TextEditingController controller;
  final bool hayBusqueda;
  final VoidCallback onBuscar;
  final VoidCallback onLimpiar;
  final String hintText;

  const BarraBusquedaCedula({
    super.key,
    required this.controller,
    required this.hayBusqueda,
    required this.onBuscar,
    required this.onLimpiar,
    this.hintText = 'Buscar por cédula del cliente',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BarraBusqueda(
        controller: controller,
        hintText: hintText,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.search,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: (_) => onBuscar(),
        suffixIcon: hayBusqueda
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: onLimpiar,
              )
            : null,
      ),
    );
  }
}
