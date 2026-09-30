import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonIniciarSesion extends StatelessWidget {
  final VoidCallback onTap;

  const BotonIniciarSesion({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF202A39),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF20BFFF)),
          ),
          child: Row(
            children: [
              const Icon(Icons.login, color: Color(0xFF20BFFF)),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Inicia sesión como cliente, empleado o administrador',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
