import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/pedidos.dart';
import 'package:google_fonts/google_fonts.dart';

// ESTA ES LA TREGTA EN LA QUE SE ONE CADA PEDIDO JUNTO CON SU ESTADO

/// Foto cuadrada con esquinas redondeadas, con cargando y respaldo si falla.
class FotoCuadrada extends StatelessWidget {
  final String? url;
  final double tam;
  final double radio;

  const FotoCuadrada({
    super.key,
    required this.url,
    this.tam = 105,
    this.radio = 18,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: tam,
      height: tam,
      color: AppColors.fondoOscuro2,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.white38,
        size: tam * 0.32,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radio),
      child: url == null
          ? placeholder
          : Image.network(
              url!,
              width: tam,
              height: tam,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progreso) {
                if (progreso == null) return child;
                return Container(
                  width: tam,
                  height: tam,
                  color: AppColors.fondoOscuro2,
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.azulClaro,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}

/// Etiqueta redondeada con el estado del pedido.
class EtiquetaEstado extends StatelessWidget {
  final String estado;
  final double fontSize;

  const EtiquetaEstado({super.key, required this.estado, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    final color = EstadoPedido.color(estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(EstadoPedido.icono(estado), color: color, size: fontSize + 3),
          const SizedBox(width: 4),
          Text(
            estado,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de un pedido en la lista: foto del primer producto, nombre y
/// apellido del cliente, su celular, total y estado.
class TarjetaPedido extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback onTap;

  const TarjetaPedido({super.key, required this.pedido, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = EstadoPedido.color(pedido.estado);
    final cliente = pedido.cliente;
    final cantidad = pedido.articulos.length;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FotoCuadrada(url: pedido.fotoPrincipal),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: EtiquetaEstado(estado: pedido.estado),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '#${pedido.id}',
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cliente?.nombreCompleto.isNotEmpty == true
                          ? cliente!.nombreCompleto
                          : 'Cliente desconocido',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          color: Colors.white54,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            cliente?.telefono ?? 'Sin celular',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cantidad == 1 ? '1 artículo' : '$cantidad artículos',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatearPesos(pedido.total),
                            style: GoogleFonts.poppins(
                              color: AppColors.azulClaro,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white54,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
