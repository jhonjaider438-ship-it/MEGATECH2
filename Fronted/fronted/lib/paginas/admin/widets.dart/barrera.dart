// lib/paginas/admin/widets.dart/barraentradachat.dart

import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';

class BarraEntradaChat extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onEnviar;
  final bool cargando;

  const BarraEntradaChat({
    super.key,
    required this.controller,
    required this.onEnviar,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.bordeTarjeta, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Escribe tu pregunta...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => cargando ? null : onEnviar(),
            ),
          ),
          cargando
              ? const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: AppColors.azulClaro),
                  onPressed: onEnviar,
                ),
        ],
      ),
    );
  }
}