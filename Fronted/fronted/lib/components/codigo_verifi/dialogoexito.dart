import 'package:flutter/material.dart';
import 'iconocirculodegradado.dart';

class DialogoExito extends StatefulWidget {
  final String mensaje;

  const DialogoExito({super.key, required this.mensaje});

  @override
  State<DialogoExito> createState() => _DialogoExitoState();
}

class _DialogoExitoState extends State<DialogoExito> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF10243F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IconoCirculoDegradado(
            icono: Icons.check,
            tamano: 80,
            tamanoIcono: 45,
          ),

          const SizedBox(height: 20),

          const Text(
            '¡Contraseña actualizada!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            widget.mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AEEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Volver al inicio de sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
