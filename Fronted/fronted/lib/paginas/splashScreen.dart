import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fronted/colores/stilocolores.dart'; // importación de colores
import 'package:fronted/paginas/bienvenida.dart'; // la pantalla a la que va después

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Espera 5 segundos y cambia de pantalla
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Bienvenida()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const azulCielo = Color(0xFF38BDF8);
    const amarillo = Color(0xFFFDE047);

    return Scaffold(
      // fondo oscuro
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradienteFondo),
        child: Center(
          // Animación de entrada: aparece y crece suavecito
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo con brillo azul neón
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Resplandor detrás del ícono
                      Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x8038BDF8),
                              blurRadius: 45,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      // Logo PNG
                      Image.asset(
                        'assets/images/logo_megatech2.png',
                        width: 240,
                        height: 240,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Nombre con colores del logo y brillo
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      shadows: const [
                        Shadow(color: Color(0xAA38BDF8), blurRadius: 20),
                      ],
                    ),
                    children: const [
                      TextSpan(
                        text: 'Mega',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Tech',
                        style: TextStyle(color: azulCielo),
                      ),
                      TextSpan(
                        text: '2',
                        style: TextStyle(color: amarillo),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Celulares · Electrodomésticos · Accesorios',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
