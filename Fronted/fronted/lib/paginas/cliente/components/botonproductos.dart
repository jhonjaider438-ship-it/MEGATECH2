import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:google_fonts/google_fonts.dart';

class Botonproductos extends StatefulWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;

  const Botonproductos({
    super.key,
    required this.icono,
    required this.texto,
    required this.onTap,
  });

  @override
  State<Botonproductos> createState() => _BotonproductosState();
}

class _BotonproductosState extends State<Botonproductos> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) => setState(() => _presionado = false),
      onTapCancel: () => setState(() => _presionado = false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        opacity: _presionado ? 0.7 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 350,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: AppColors.gradienteBoton,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icono, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                widget.texto,
                style: GoogleFonts.acme(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
