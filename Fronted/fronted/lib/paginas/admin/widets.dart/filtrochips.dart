import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fila de chips de filtro. La opción `null` se muestra como [textoTodos].
class FiltroChips extends StatelessWidget {
  final List<String?> opciones;
  final String? seleccionado;
  final ValueChanged<String?> onSeleccionar;
  final Color Function(String? opcion) colorDe;
  final String textoTodos;

  const FiltroChips({
    super.key,
    required this.opciones,
    required this.seleccionado,
    required this.onSeleccionar,
    required this.colorDe,
    this.textoTodos = 'Todos',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: opciones.map((opcion) {
          final activo = seleccionado == opcion;
          final color = colorDe(opcion);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () => onSeleccionar(opcion),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: activo ? color : color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 1),
                  ),
                  child: Text(
                    opcion ?? textoTodos,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: activo ? Colors.black : color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}