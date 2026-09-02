import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';
import '../admin/widets.dart/registrarventas.dart';

class Registarventas extends StatefulWidget {
  const Registarventas({super.key});

  @override
  State<Registarventas> createState() => _RegistarventasState();
}

class _RegistarventasState extends State<Registarventas> {
  List<Map<String, TextEditingController>> productos = [];
  @override
void initState() {
  super.initState();
  agregarProducto();
}

void agregarProducto() {
  setState(() {
    productos.add({
      'id': TextEditingController(),
      'cantidad': TextEditingController(),
    });
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // FONDO
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF173A55), Color(0xFF0B202E), Color(0xFF06141D)],
          ),
        ),
        child: SafeArea(child: SingleChildScrollView(child: Column(
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
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: 5,
                    bottom: 10,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 54,
                      height: 43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF29B6F6),
                            Color(0xFF0288D1),
                          ],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Center(
                            child: Icon(
                              Icons.undo,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        ),
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
                  child: SizedBox(
                    height: 43,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Registrar ventas',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: AppColors.azulOscuro,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.white, thickness: 1, height: 20),
                // targetas y contenido de la pantalla
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [

                      // mostar las taregetas
                      ...productos.map(
                        (producto) {
                          return TarjetaProducto(
                            idController: producto['id']!,
                            cantidadController: producto['cantidad']!,
                          );
                        },
                      ),

                      // agregar otro producto 
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: agregarProducto,
                          icon: const Icon(Icons.add),
                          label: Text(
                            'Agregar otro producto',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0288D1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
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
