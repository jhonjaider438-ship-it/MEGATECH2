import 'package:flutter/material.dart';

/// Carrusel de imágenes listo para usar dentro de cualquier pantalla.
/// Uso:  const Carrusel()
class Carrusel extends StatefulWidget {
  const Carrusel({super.key});

  @override
  State<Carrusel> createState() => _CarruselState();
}

class _CarruselState extends State<Carrusel> {
  // Controla las páginas del PageView
  final PageController _controller = PageController();

  // Índice de la imagen visible
  int paginaActual = 0;

  // Imágenes del carrusel (cámbialas por las tuyas)
  final List<String> imagenes = [
    'assets/images/celular.jpg',
    'assets/images/cargador.jpg',
    'assets/images/licuadora.jpg',
    'assets/images/bolso.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),

        // Carrusel
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _controller,
            itemCount: imagenes.length,
            onPageChanged: (index) {
              setState(() {
                paginaActual = index;
              });
            },

            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(blurRadius: 8, offset: Offset(0, 4)),
                  ],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imagenes[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // Indicadores
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: List.generate(imagenes.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),

              width: paginaActual == index ? 20 : 10,
              height: 10,

              decoration: BoxDecoration(
                color: paginaActual == index ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
