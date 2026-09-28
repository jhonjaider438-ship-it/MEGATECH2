import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fronted/components/Bienvenida/fondo.dart';
import 'package:fronted/components/Bienvenida/texto_degradado.dart';
import 'package:fronted/components/Bienvenida/boton_degradado.dart';

class Bienvenida extends StatefulWidget {
  const Bienvenida({super.key});

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FondoDegradado(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 3),

                Text(
                  'Bienvenido a',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                const TextoDegradado(texto: 'Megatech', fontSize: 34),

                const SizedBox(height: 8),

                const TextoDegradado(texto: '2', fontSize: 32),

                const SizedBox(height: 24),

                Text(
                  'En Megatech 2 te ofrecemos lo mejor en tecnología '
                  'con una experiencia rápida, segura y confiable para '
                  'que compres sin complicaciones.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),

                const Spacer(flex: 3),

                BotonDegradado(texto: 'Explorar tienda', onTap: () {}),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
