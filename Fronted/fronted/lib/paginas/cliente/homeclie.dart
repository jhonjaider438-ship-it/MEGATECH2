import 'package:flutter/material.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/paginas/admin/perfil.dart';
import 'package:fronted/paginas/admin/widets.dart/barranavega.dart';
import 'package:fronted/paginas/cliente/components/carrusel.dart';
import 'package:fronted/paginas/cliente/components/encabesadosinico.dart';
import 'package:fronted/paginas/cliente/iacliente.dart';
import 'package:google_fonts/google_fonts.dart';

class Homeclie extends StatefulWidget {
  final String cedula;
  final String nombre;
  final String apellido;
  final String telefono;
  final String correo;

  const Homeclie({
    super.key,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
  });

  @override
  State<Homeclie> createState() => _HomeclieState();
}

class _HomeclieState extends State<Homeclie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Barranavegacioninferior(
        botones: [
          BotonNav(
            icon: Icons.smart_toy,
            size: 26,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Iacliente()),
              );
            },
          ),
          BotonNav(
            icon: Icons.person,
            size: 28,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar productos...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF20BFFF),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF202A39),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF20BFFF),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const Carrusel(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 0,
                    bottom: 15,
                  ),
                  child: EncabesadoSinIcono(
                    title: 'Nuestros productos mas comprados',
                    subtitle:
                        'Aqui encontraras nuestros productos mas comprados',
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
