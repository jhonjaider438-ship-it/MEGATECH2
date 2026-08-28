import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Targetas extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final Color colorTitulo;
  final Color colorBorde;
  final String textoBoton;
  final VoidCallback onPressed;

  const Targetas({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.colorTitulo,
    required this.colorBorde,
    required this.textoBoton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Container(

          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: colorBorde, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: colorTitulo,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                textAlign: TextAlign.center,
                descripcion,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3FA9F5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: Text(textoBoton, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
