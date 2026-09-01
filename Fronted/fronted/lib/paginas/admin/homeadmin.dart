import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/paginas/admin/actualizarinventario.dart';
import 'package:fronted/paginas/admin/bajostock.dart';
import 'package:fronted/paginas/admin/gestioncontable.dart';
import 'package:fronted/paginas/admin/gestiondeusuarios.dart';
import 'package:fronted/paginas/admin/pedidos.dart';
import 'package:fronted/paginas/admin/registarventas.dart';
import 'package:fronted/paginas/admin/revisarinventario.dart';
import 'package:fronted/paginas/admin/veririfcartrnsferencias.dart';
import 'package:google_fonts/google_fonts.dart';
import '../admin/widets.dart/targetas.dart';
import 'package:fronted/service/desboard.dart';

class Homeadmin extends StatefulWidget {
  final String nombre;

  const Homeadmin({super.key, required this.nombre});

  @override
  State<Homeadmin> createState() => _HomeadminState();
}

class _HomeadminState extends State<Homeadmin> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // FONDO
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF173A55), Color(0xFF0B202E), Color(0xFF06141D)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Megatech 2',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          // Círculo del robot
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
                              ),
                            ),
                            child: const Icon(
                              Icons.smart_toy,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),

                          const SizedBox(width: 10),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                      Column(
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

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1F2937),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: const Color(0xFF1BC2F0),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            cargandoPedidos
                                                ? '...'
                                                : '$pedidosPorEntregar',
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              color: const Color(0xFF1BC2F0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Pedidos por entregar',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1F2937),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: const Color(0xFF1BC2F0),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            cargandoStock
                                                ? '...'
                                                : '$productosBajoStock',
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              color: const Color.fromARGB(
                                                255,
                                                236,
                                                4,
                                                4,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Productos en bajo stock',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Targetas(
                                  titulo: 'Bajo stok',
                                  descripcion:
                                      'productos que estan en unidades criticas',
                                  colorTitulo: AppColors.azulClaro,
                                  colorBorde: AppColors.bordeTarjeta,
                                  textoBoton: 'Revisar',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Bajostock(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Targetas(
                                  titulo: 'Pedidos',
                                  descripcion:
                                      'Pedidos echos por la app que deben de ser entregados',
                                  colorTitulo: AppColors.azulClaro,
                                  colorBorde: AppColors.bordeTarjeta,
                                  textoBoton: 'Colsultar',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Pedidos(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Targetas(
                                  titulo: 'Registrar ventas',
                                  descripcion:
                                      'Registrar ventas fisicas',
                                  colorTitulo: AppColors.azulClaro,
                                  colorBorde: AppColors.bordeTarjeta,
                                  textoBoton: 'Registrar',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Registarventas(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Targetas(
                                  titulo: 'Inventario',
                                  descripcion: 'Revisar inventario',
                                  colorTitulo: AppColors.azulClaro,
                                  colorBorde: AppColors.bordeTarjeta,
                                  textoBoton: 'Colsultar',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Revisarinventario(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Targetas(
                                  titulo: 'Gestion contable',
                                  descripcion: 'Revisar gestion contable',
                                  colorTitulo: AppColors.azulClaro,
                                  colorBorde: AppColors.bordeTarjeta,
                                  textoBoton: 'Consultar',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Gestioncontable(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Targetas(
                                  titulo: 'Actualizar inventario',
                                  descripcion: 'Modidificar inventario',
                                  colorTitulo: AppColors.azulClaro,
                                  colorBorde: AppColors.bordeTarjeta,
                                  textoBoton: 'Ingresar',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Actualizarinventario(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Targetas(
                                  titulo: 'Gestion de usuarios',
                                  descripcion:
                                      'Modificar informacion de los usuarios',
                                  colorTitulo: AppColors.azulClaro,
                                  colorBorde: AppColors.bordeTarjeta,
                                  textoBoton: 'Modificar',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Gestiondeusuarios(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Targetas(
                                  titulo: 'verificar transferencias',
                                  descripcion:
                                      'Verificar las transferencias de los pagos de los pedidos',
                                  colorTitulo: AppColors.azulClaro,
                                  colorBorde: AppColors.bordeTarjeta,
                                  textoBoton: 'Consultar',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Veririfcartrnsferencias(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
