import 'package:flutter/material.dart';
import 'package:fronted/model/gestioncontable.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/chipsselec.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/seecdropfiltro.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/selecrangorechas.dart';

/// Filtros del reporte: periodo, rango de fechas, vendedor, categoría y subcategoría.
/// Modifica [filtros] directamente y avisa con [onCambio] para que el padre redibuje.
class PanelFiltrosReporte extends StatelessWidget {
  final FiltrosReporte filtros;
  final List<OpcionFiltro> vendedores;
  final List<OpcionFiltro> categorias;
  final List<OpcionFiltro> subcategorias;
  final VoidCallback onCambio;

  const PanelFiltrosReporte({
    super.key,
    required this.filtros,
    required this.vendedores,
    required this.categorias,
    required this.subcategorias,
    required this.onCambio,
  });

  static const _periodos = {
    'hoy': 'Hoy',
    'semana': 'Semana',
    'mes': 'Mes',
    'rango': 'Rango',
  };

  @override
  Widget build(BuildContext context) {
    // Las subcategorías se limitan a la categoría elegida.
    final subs = filtros.idCategoria == null
        ? subcategorias
        : subcategorias.where((s) => s.idPadre == filtros.idCategoria).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipsSeleccion<String>(
          opciones: _periodos,
          valor: filtros.periodo,
          onCambio: (v) {
            filtros.periodo = v;
            onCambio();
          },
        ),
        if (filtros.periodo == 'rango') ...[
          const SizedBox(height: 10),
          SelectorRangoFechas(
            inicio: filtros.inicio,
            fin: filtros.fin,
            onCambio: (i, f) {
              filtros.inicio = i;
              filtros.fin = f;
              onCambio();
            },
          ),
        ],
        const SizedBox(height: 12),
        DropdownFiltro(
          hint: 'Vendedor',
          valor: filtros.idVendedor,
          opciones: vendedores,
          onChanged: (v) {
            filtros.idVendedor = v;
            onCambio();
          },
        ),
        const SizedBox(height: 10),
        DropdownFiltro(
          hint: 'Categoría',
          valor: filtros.idCategoria,
          opciones: categorias,
          onChanged: (v) {
            filtros.idCategoria = v;
            filtros.idSubcategoria = null; // la subcategoría ya no aplica
            onCambio();
          },
        ),
        const SizedBox(height: 10),
        DropdownFiltro(
          hint: 'Subcategoría',
          valor: filtros.idSubcategoria,
          opciones: subs,
          onChanged: (v) {
            filtros.idSubcategoria = v;
            onCambio();
          },
        ),
      ],
    );
  }
}
