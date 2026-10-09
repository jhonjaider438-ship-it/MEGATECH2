import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/tablareporte.dart';
import 'package:fronted/paginas/admin/widets.dart/gestioncontable/tablaventas.dart';
import 'package:fronted/paginas/admin/widets.dart/pantallaadmin.dart';
import 'package:google_fonts/google_fonts.dart';

class Gestioncontable extends StatelessWidget {
  const Gestioncontable({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: PantallaAdmin(
        titulo: 'Gestión contable',
        child: Column(
          children: [
            TabBar(
              indicatorColor: AppColors.azulClaro,
              labelColor: AppColors.azulClaro,
              unselectedLabelColor: Colors.white60,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Reporte'),
                Tab(text: 'Ventas'),
              ],
            ),
            const Expanded(
              child: TabBarView(children: [TabReporte(), TabVentas()]),
            ),
          ],
        ),
      ),
    );
  }
}
