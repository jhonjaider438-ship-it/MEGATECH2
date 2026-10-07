import 'package:flutter/material.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/model/pedidos.dart';
import 'package:fronted/paginas/admin/widets.dart/barranavega.dart';
import 'package:fronted/paginas/admin/widets.dart/targetapedido.dart';
import 'package:fronted/service/pedidos.dart';
import 'package:google_fonts/google_fonts.dart';

/// Subpantalla con todo el detalle de un pedido:
/// datos del cliente, artículos (foto, descripción, precio unitario, subtotal),
/// total final y botón para cambiar el estado (guarda en la base de datos).
class DetallePedido extends StatefulWidget {
  final Pedido pedido;

  const DetallePedido({super.key, required this.pedido});

  @override
  State<DetallePedido> createState() => _DetallePedidoState();
}

class _DetallePedidoState extends State<DetallePedido> {
  final PedidosService _service = PedidosService();
  late Pedido _pedido;
  bool _cambiando = false;

  @override
  void initState() {
    super.initState();
    _pedido = widget.pedido;
  }

  // ---------------------------------------------------------------- estado

  void _mostrarMensaje(String texto, {Color? color, IconData? icono}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1F2937),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: color ?? AppColors.azulClaro),
          ),
          content: Row(
            children: [
              Icon(icono ?? Icons.info_outline, color: color ?? Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  texto,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
  }

  /// Abre la hoja con los estados. Solo el siguiente estado permitido por el
  /// backend queda habilitado.
  Future<void> _abrirSelectorEstado() async {
    final siguiente = EstadoPedido.siguiente(_pedido.estado);

    final elegido = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          decoration: const BoxDecoration(
            color: Color(0xFF1F2937),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: AppColors.bordeTarjeta, width: 1.5),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Cambiar estado del pedido',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                for (final estado in EstadoPedido.todos)
                  _opcionEstado(ctx, estado, siguiente),
              ],
            ),
          ),
        );
      },
    );

    if (elegido != null) _confirmarCambio(elegido);
  }

  Widget _opcionEstado(BuildContext ctx, String estado, String? siguiente) {
    final color = EstadoPedido.color(estado);
    final esActual = estado == _pedido.estado;
    final habilitado = estado == siguiente;

    String trailing;
    if (esActual) {
      trailing = 'Actual';
    } else if (habilitado) {
      trailing = 'Disponible';
    } else {
      trailing = 'No disponible';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: (esActual || habilitado) ? 1 : 0.4,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: habilitado ? () => Navigator.pop(ctx, estado) : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(esActual ? 0.18 : 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color, width: esActual ? 2 : 1),
              ),
              child: Row(
                children: [
                  Icon(EstadoPedido.icono(estado), color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      estado,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    trailing,
                    style: GoogleFonts.poppins(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarCambio(String nuevoEstado) async {
    final color = EstadoPedido.color(nuevoEstado);
    final avisoCorreo = nuevoEstado == EstadoPedido.porEntregar
        ? '\n\nSe le enviará un correo de confirmación al cliente.'
        : '';

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: color, width: 1.5),
        ),
        title: Text(
          'Confirmar cambio',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'El pedido #${_pedido.id} pasará de "${_pedido.estado}" '
          'a "$nuevoEstado".$avisoCorreo',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Confirmar',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmado == true) _aplicarCambio(nuevoEstado);
  }

  /// Llama al backend (PUT /pedidos/actualizar/:id). Solo si el backend
  /// responde bien se actualiza lo que se ve en pantalla.
  Future<void> _aplicarCambio(String nuevoEstado) async {
    setState(() => _cambiando = true);
    try {
      await _service.cambiarEstado(_pedido.id, nuevoEstado);
      if (!mounted) return;
      setState(() => _pedido = _pedido.copyWith(estado: nuevoEstado));
      _mostrarMensaje(
        'Pedido actualizado a "$nuevoEstado"',
        color: EstadoPedido.color(nuevoEstado),
        icono: Icons.check_circle_outline_rounded,
      );
    } on PedidoException catch (e) {
      if (!mounted) return;
      if (e.aplicado) {
        // El estado SÍ quedó guardado en la base de datos; falló algo después
        // (por ejemplo el correo al cliente).
        setState(() => _pedido = _pedido.copyWith(estado: nuevoEstado));
        _mostrarMensaje(
          e.mensaje,
          color: const Color(0xFFFFA726),
          icono: Icons.warning_amber_rounded,
        );
      } else {
        _mostrarMensaje(
          e.mensaje,
          color: const Color(0xFFFF5252),
          icono: Icons.error_outline_rounded,
        );
      }
    } catch (_) {
      _mostrarMensaje(
        'No se pudo conectar con el servidor',
        color: const Color(0xFFFF5252),
        icono: Icons.wifi_off_rounded,
      );
    } finally {
      if (mounted) setState(() => _cambiando = false);
    }
  }

  // ------------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Barranavegacioninferior(
        botones: [
          BotonNav(
            icon: Icons.arrow_back,
            size: 26,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Fondo(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 20,
                ),
                child: Center(
                  child: Text(
                    'Megatech 2',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(
                'Pedido #${_pedido.id}',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1BC2F0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  children: [
                    _tarjetaCliente(),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(left: 6, bottom: 10),
                      child: Text(
                        'Artículos (${_pedido.articulos.length})',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_pedido.articulos.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'Este pedido no tiene artículos',
                            style: GoogleFonts.poppins(color: Colors.white70),
                          ),
                        ),
                      ),
                    for (final articulo in _pedido.articulos) ...[
                      _tarjetaArticulo(articulo),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
              _panelInferior(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarjetaCliente() {
    final cliente = _pedido.cliente;
    final color = EstadoPedido.color(_pedido.estado);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EtiquetaEstado(estado: _pedido.estado, fontSize: 12),
          const SizedBox(height: 10),
          _filaDato(
            Icons.person_outline_rounded,
            cliente?.nombreCompleto.isNotEmpty == true
                ? cliente!.nombreCompleto
                : 'Cliente desconocido',
            fuerte: true,
          ),
          const SizedBox(height: 6),
          _filaDato(Icons.phone_outlined, cliente?.telefono ?? 'Sin celular'),
          if (cliente?.correo != null) ...[
            const SizedBox(height: 6),
            _filaDato(Icons.email_outlined, cliente!.correo!),
          ],
          const SizedBox(height: 6),
          _filaDato(Icons.event_outlined, _pedido.fecha),
        ],
      ),
    );
  }

  Widget _filaDato(IconData icono, String texto, {bool fuerte = false}) {
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

  Widget _tarjetaArticulo(ArticuloPedido a) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.bordeTarjeta.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FotoCuadrada(url: a.foto, tam: 90, radio: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  a.descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${a.cantidad} × ${formatearPesos(a.precioUnitario)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Subtotal  ',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        formatearPesos(a.subtotal),
                        style: GoogleFonts.poppins(
                          color: AppColors.azulClaro,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Total final + botón de estado, siempre visibles al final de la pantalla.
  Widget _panelInferior() {
    final color = EstadoPedido.color(_pedido.estado);
    final puedeCambiar = EstadoPedido.siguiente(_pedido.estado) != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0B202E),
        border: Border(top: BorderSide(color: Color(0xFF1BC2F0), width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Total del pedido',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
              const Spacer(),
              Text(
                formatearPesos(_pedido.total),
                style: GoogleFonts.poppins(
                  color: AppColors.azulClaro,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: (_cambiando || !puedeCambiar)
                  ? null
                  : _abrirSelectorEstado,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.black,
                disabledBackgroundColor: color.withOpacity(0.75),
                disabledForegroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: _cambiando
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.black,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(EstadoPedido.icono(_pedido.estado), size: 22),
                        const SizedBox(width: 8),
                        Text(
                          _pedido.estado,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          puedeCambiar
                              ? Icons.swap_horiz_rounded
                              : Icons.lock_outline_rounded,
                          size: 22,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
