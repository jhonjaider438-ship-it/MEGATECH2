import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/gestioncontable.dart' show fechaIso;
import 'package:google_fonts/google_fonts.dart';

// PARA BUSCA POR FECHA PERSONALIZADA

/// Dos botones "Desde" / "Hasta" que abren el calendario.
class SelectorRangoFechas extends StatelessWidget {
  final DateTime? inicio;
  final DateTime? fin;
  final void Function(DateTime? inicio, DateTime? fin) onCambio;

  const SelectorRangoFechas({
    super.key,
    required this.inicio,
    required this.fin,
    required this.onCambio,
  });

  Future<void> _elegir(BuildContext context, bool esInicio) async {
    final hoy = DateTime.now();
    final f = await showDatePicker(
      context: context,
      initialDate: (esInicio ? inicio : fin) ?? hoy,
      firstDate: DateTime(2020),
      lastDate: DateTime(hoy.year + 1),
    );
    if (f == null) return;
    esInicio ? onCambio(f, fin) : onCambio(inicio, f);
  }

  Widget _boton(
    BuildContext context,
    String etiqueta,
    DateTime? fecha,
    bool esInicio,
  ) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () => _elegir(context, esInicio),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: AppColors.azulClaro),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.calendar_today, size: 16),
        label: Text(
          fecha == null ? etiqueta : fechaIso(fecha),
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _boton(context, 'Desde', inicio, true),
        const SizedBox(width: 10),
        _boton(context, 'Hasta', fin, false),
      ],
    );
  }
}
