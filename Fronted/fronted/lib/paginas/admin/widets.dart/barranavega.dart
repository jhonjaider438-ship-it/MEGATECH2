import 'package:flutter/material.dart';
class BotonNav {
  final IconData icon;
  final double size;
  final VoidCallback? onTap;

  const BotonNav({required this.icon, this.size = 26, this.onTap});
}
class Barranavegacioninferior extends StatelessWidget {
  final List<BotonNav> botones;
  final double espacioEntreBotones;

  const Barranavegacioninferior({
    super.key,
    required this.botones,
    this.espacioEntreBotones = 24,
  });

  Widget _boton(BotonNav boton) {
    return GestureDetector(
      onTap: boton.onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
          ),
        ),
        child: Icon(boton.icon, color: Colors.white, size: boton.size),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B202E),
        border: Border(top: BorderSide(color: Color(0xFF1BC2F0), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < botones.length; i++) ...[
                if (i > 0) SizedBox(width: espacioEntreBotones),
                _boton(botones[i]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}