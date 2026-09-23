import 'package:flutter/material.dart';
import 'package:fronted/paginas/admin/perfil.dart';

/// Barra de navegacion fija en la parte baja de la pantalla, con los
/// accesos a Perfil y al asistente IA. Se usa como `bottomNavigationBar`
/// del Scaffold, por lo que queda siempre visible aunque el contenido de
/// la pantalla haga scroll.
class Barranavegacioninferior extends StatelessWidget {
  final String cedula;
  final String nombre;
  final String apellido;
  final String telefono;
  final String correo;
  final VoidCallback? onPerfilTap;
  final VoidCallback? onIaTap;

  const Barranavegacioninferior({
    super.key,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
    this.onPerfilTap,
    this.onIaTap,
  });

  Widget _boton({
    required IconData icon,
    required double size,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
          ),
        ),
        child: Icon(icon, color: Colors.white, size: size),
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
              _boton(icon: Icons.smart_toy, size: 26, onTap: onIaTap),
              const SizedBox(width: 24),
              _boton(
                icon: Icons.person,
                size: 28,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Perfil(
                        cedula: cedula,
                        nombre: nombre,
                        apellido: apellido,
                        telefono: telefono,
                        correo: correo,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
