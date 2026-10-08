import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/model/pedidos.dart';
import 'package:fronted/paginas/admin/widets.dart/targetapedido.dart';
import 'package:google_fonts/google_fonts.dart';

/// Datos del cliente y estado del pedido (parte superior del detalle).
class TarjetaClientePedido extends StatelessWidget {
  final Pedido pedido;

  const TarjetaClientePedido({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    final cliente = pedido.cliente;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: EstadoPedido.color(pedido.estado), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EtiquetaEstado(estado: pedido.estado, fontSize: 12),
          const SizedBox(height: 10),
          _FilaDato(
            Icons.person_outline_rounded,
            cliente?.nombreCompleto.isNotEmpty == true
                ? cliente!.nombreCompleto
                : 'Cliente desconocido',
            fuerte: true,
          ),
          const SizedBox(height: 6),
          _FilaDato(Icons.phone_outlined, cliente?.telefono ?? 'Sin celular'),
          if (cliente?.correo != null) ...[
            const SizedBox(height: 6),
            _FilaDato(Icons.email_outlined, cliente!.correo!),
          ],
          const SizedBox(height: 6),
          _FilaDato(Icons.event_outlined, pedido.fecha),
        ],
      ),
    );
  }
}

class _FilaDato extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool fuerte;

  const _FilaDato(this.icono, this.texto, {this.fuerte = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, color: AppColors.azulClaro, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: GoogleFonts.poppins(
              color: fuerte ? Colors.white : Colors.white70,
              fontSize: fuerte ? 16 : 13,
              fontWeight: fuerte ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}