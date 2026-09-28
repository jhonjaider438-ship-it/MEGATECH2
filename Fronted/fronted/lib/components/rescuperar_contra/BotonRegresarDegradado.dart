import 'package:flutter/material.dart';

class BotonRegresarDegradado extends StatefulWidget {
  final VoidCallback onPressed;

  const BotonRegresarDegradado({super.key, required this.onPressed});

  @override
  State<BotonRegresarDegradado> createState() => _BotonRegresarDegradadoState();
}

class _BotonRegresarDegradadoState extends State<BotonRegresarDegradado> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
            ),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
