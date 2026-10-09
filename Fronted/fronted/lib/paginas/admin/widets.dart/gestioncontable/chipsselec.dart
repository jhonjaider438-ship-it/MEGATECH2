import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

// BOTONES PEQUEÑO PARA LOS FILTROS

/// Fila de chips de selección única. [opciones] mapea valor -> texto visible.
class ChipsSeleccion<T> extends StatelessWidget {
  final Map<T, String> opciones;
  final T valor;
  final ValueChanged<T> onCambio;

  const ChipsSeleccion({
    super.key,
    required this.opciones,
    required this.valor,
    required this.onCambio,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final e in opciones.entries)
          ChoiceChip(
            label: Text(e.value, style: GoogleFonts.poppins(fontSize: 12)),
            selected: valor == e.key,
            selectedColor: AppColors.azulClaro,
            backgroundColor: AppColors.fondoTarjeta,
            labelStyle: TextStyle(
              color: valor == e.key ? Colors.black : Colors.white,
            ),
            onSelected: (_) => onCambio(e.key),
          ),
      ],
    );
  }
}
