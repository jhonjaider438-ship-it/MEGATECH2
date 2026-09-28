import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/paginas/admin/bajostock.dart';
import 'package:fronted/paginas/admin/perfil.dart';
import 'package:fronted/paginas/admin/registarventas.dart';
import 'package:fronted/paginas/admin/widets.dart/barranavega.dart';
import 'package:fronted/paginas/admin/widets.dart/targetas.dart';
import 'package:fronted/paginas/admin/widets.dart/targetasesta.dart';
import 'package:fronted/paginas/empleado/pedidosemple.dart';
import 'package:fronted/service/desboard.dart';
import 'package:google_fonts/google_fonts.dart';

class Homeemple extends StatefulWidget {
  final String cedula;
  final String nombre;
  final String apellido;
  final String telefono;
  final String correo;

  const Homeemple({
    super.key,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
  });

  @override
  State<Homeemple> createState() => _HomeempleState();
}

class _HomeempleState extends State<Homeemple> {
  final DashboardService _dashboardService = DashboardService();

  int pedidosPorEntregar = 0;
  bool cargandoPedidos = true;

  int productosBajoStock = 0;
  bool cargandoStock = true;

  @override
  void initState() {
    super.initState();
    cargarPedidos();
    cargarBajoStock();
  }

  Future<void> cargarPedidos() async {
    try {
      final total = await _dashboardService.obtenerPedidosPorEntregar();
      if (mounted) {
        setState(() {
          pedidosPorEntregar = total;
          cargandoPedidos = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => cargandoPedidos = false);
    }
  }

  Future<void> cargarBajoStock() async {
    try {
      final total = await _dashboardService.obtenerProductosBajoStock();
      if (mounted) {
        setState(() {
          productosBajoStock = total;
          cargandoStock = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => cargandoStock = false);
    }
  }

  // Navega a una pantalla del panel, evitando repetir Navigator.push 8 veces
  void _ir(Widget pagina) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pagina));
  }

  // Una fila con dos tarjetas que se estiran a la misma altura (la de la
  // tarjeta más alta), sin importar cuánto texto tenga cada una. Así nunca
  // se desborda y ambas quedan siempre del mismo tamaño.
  Widget _filaTarjetas(Widget izquierda, Widget derecha) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: izquierda),
            const SizedBox(width: 10),
            Expanded(child: derecha),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Barranavegacioninferior(
        botones: [
          BotonNav(
            icon: Icons.person,
            size: 26,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Perfil(
                    cedula: widget.cedula,
                    nombre: widget.nombre,
                    apellido: widget.apellido,
                    telefono: widget.telefono,
                    correo: widget.correo,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Fondo(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 20,
                  ),
                  child: Center(
                    child: Text(
                      'Megatech 2',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const Divider(color: Colors.white, thickness: 1, height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hola, ${widget.nombre}',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF1BC2F0),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _filaTarjetas(
                        Tarjetaestadistica(
                          valor: cargandoPedidos
                              ? '...'
                              : '$pedidosPorEntregar',
                          etiqueta: 'Pedidos por entregar',
                          colorValor: const Color(0xFF1BC2F0),
                          colorBorde: AppColors.bordeTarjeta,
                        ),
                        Tarjetaestadistica(
                          valor: cargandoStock ? '...' : '$productosBajoStock',
                          etiqueta: 'Productos en bajo stock',
                          colorValor: const Color.fromARGB(255, 236, 4, 4),
                          colorBorde: AppColors.bordeTarjeta,
                        ),
                      ),

                      _filaTarjetas(
                        Targetas(
                          titulo: 'Bajo stok',
                          descripcion:
                              'productos que estan en unidades criticas',
                          colorTitulo: AppColors.azulClaro,
                          colorBorde: AppColors.bordeTarjeta,
                          textoBoton: 'Revisar',
                          onPressed: () => _ir(const Bajostock()),
                        ),
                        Targetas(
                          titulo: 'Pedidos',
                          descripcion:
                              'Pedidos echos por la app que deben de ser entregados',
                          colorTitulo: AppColors.azulClaro,
                          colorBorde: AppColors.bordeTarjeta,
                          textoBoton: 'Colsultar',
                          onPressed: () => _ir(const Pedidosemple()),
                        ),
                      ),

                      Targetas(
                        titulo: 'Registrar ventas',
                        descripcion: 'Registrar ventas fisicas',
                        colorTitulo: AppColors.azulClaro,
                        colorBorde: AppColors.bordeTarjeta,
                        textoBoton: 'Registrar',
                        onPressed: () => _ir(const Registarventas()),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
