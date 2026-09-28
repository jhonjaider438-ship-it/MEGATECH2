import 'package:flutter/material.dart';

class TarjetaFormulario extends StatefulWidget {
  final Widget child;

  const TarjetaFormulario({super.key, required this.child});

  @override
  State<TarjetaFormulario> createState() => _TarjetaFormularioState();
}

class _TarjetaFormularioState extends State<TarjetaFormulario> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF0D223A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF00D2FF), width: 1.5),
      ),
      child: widget.child,
    );
  }
}
