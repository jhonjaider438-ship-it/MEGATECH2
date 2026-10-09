import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/gestioncontable.dart';
import 'package:google_fonts/google_fonts.dart';

// ESTE CREA LOS FILTROS

/// Desplegable de filtro con la opción "<hint>: todos" (valor null).
class DropdownFiltro extends StatelessWidget {
  final String hint;
  final String? valor;
  final List<OpcionFiltro> opciones;
  final ValueChanged<String?> onChanged;

  const DropdownFiltro({
    super.key,
    required this.hint,
    required this.valor,
    required this.opciones,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final estilo = GoogleFonts.poppins(fontSize: 13);
    return DropdownButtonFormField<String?>(
      // ignore: deprecated_member_use
      value: valor,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.fondoCampo,
        hintText: hint,
        hintStyle: estilo,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: [
        DropdownMenuItem<String?>(
          value: null,
          child: Text('$hint: todos', style: estilo),
        ),
        for (final o in opciones)
          DropdownMenuItem<String?>(
            value: o.id,
            child: Text(
              o.nombre,
              overflow: TextOverflow.ellipsis,
              style: estilo,
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
