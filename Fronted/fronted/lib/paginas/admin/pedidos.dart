import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fronted/colores/stilocolores.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/model/pedidos.dart';
import 'package:fronted/paginas/admin/detallepedido.dart';
import 'package:fronted/paginas/admin/widets.dart/barranavega.dart';
import 'package:fronted/paginas/admin/widets.dart/targetapedido.dart';
import 'package:fronted/paginas/cliente/components/barradebusqueda.dart';
import 'package:fronted/service/pedidos.dart';
import 'package:google_fonts/google_fonts.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({super.key});

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  final PedidosService _service = PedidosService();
  late Future<List<Pedido>> _futuroPedidos;

  final TextEditingController _cedulaCtrl = TextEditingController();

  /// null = "Todos"
  String? _filtro;

  /// null = sin búsqueda (se muestran todos los pedidos)
  String? _cedulaBuscada;

  /// Pide todos los pedidos, o solo los del cliente si hay una cédula buscada.
  Future<List<Pedido>> _cargar() => _cedulaBuscada == null
      ? _service.obtenerPedidos()
      : _service.obtenerPedidosPorCedula(_cedulaBuscada!);

  @override
  void initState() {
    super.initState();
    _futuroPedidos = _cargar();
  }

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    super.dispose();
  }

  void _buscarPorCedula() {
    FocusScope.of(context).unfocus();
    final cedula = _cedulaCtrl.text.trim();
    if (cedula.isEmpty) {
      _limpiarBusqueda();
      return;
    }
    setState(() {
      _cedulaBuscada = cedula;
      _futuroPedidos = _cargar();
    });
  }

  void _limpiarBusqueda() {
    _cedulaCtrl.clear();
    setState(() {
      _cedulaBuscada = null;
      _futuroPedidos = _cargar();
    });
  }

  /// Vuelve a pedir los datos al backend (Reintentar, pull-to-refresh y
  /// cuando se regresa del detalle, para que se vea lo que quedó en la BD).
  Future<void> _recargar() async {
    setState(() {
      _futuroPedidos = _cargar();
    });
    await _futuroPedidos.catchError((_) => <Pedido>[]);
  }

  Future<void> _abrirDetalle(Pedido pedido) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetallePedido(pedido: pedido)),
    );
    if (mounted) _recargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Barranavegacioninferior(
        botones: [
          BotonNav(
            icon: Icons.arrow_back,
            size: 26,
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
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
                'Pedidos',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1BC2F0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BarraBusqueda(
                  controller: _cedulaCtrl,
                  hintText: 'Buscar por cédula del cliente',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.search,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: (_) => _buscarPorCedula(),
                  suffixIcon: _cedulaBuscada == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: _limpiarBusqueda,
                        ),
                ),
              ),
              const SizedBox(height: 14),
              _filtros(),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<Pedido>>(
                  future: _futuroPedidos,
                  builder: (context, snapshot) {
                    // 1) Cargando
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.azulClaro,
                        ),
                      );
                    }

                    // 2) Error
                    if (snapshot.hasError) {
                      return _mensaje(
                        icono: Icons.wifi_off_rounded,
                        texto: 'No se pudieron cargar los pedidos',
                        conBoton: true,
                      );
                    }

                    // 3) Filtrar
                    final todos = snapshot.data ?? [];
                    final pedidos = _filtro == null
                        ? todos
                        : todos.where((p) => p.estado == _filtro).toList();

                    if (pedidos.isEmpty) {
                      return RefreshIndicator(
                        color: AppColors.azulClaro,
                        onRefresh: _recargar,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: 320,
                              child: _mensaje(
                                icono: Icons.inbox_outlined,
                                texto: _cedulaBuscada != null
                                    ? 'No hay pedidos para la cédula $_cedulaBuscada'
                                    : _filtro == null
                                    ? 'Todavía no hay pedidos'
                                    : 'No hay pedidos "$_filtro"',
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // 4) Lista de tarjetas
                    return RefreshIndicator(
                      color: AppColors.azulClaro,
                      onRefresh: _recargar,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                        itemCount: pedidos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, i) => TarjetaPedido(
                          pedido: pedidos[i],
                          onTap: () => _abrirDetalle(pedidos[i]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Chips: Todos / Por pagar / Por entregar / Entregado
  Widget _filtros() {
    final opciones = <String?>[null, ...EstadoPedido.todos];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: opciones.map((estado) {
          final seleccionado = _filtro == estado;

          final color = estado == null
              ? AppColors.azulClaro
              : EstadoPedido.color(estado);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () => setState(() => _filtro = estado),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: seleccionado ? color : color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 1),
                  ),
                  child: Text(
                    estado ?? 'Todos',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: seleccionado ? Colors.black : color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _mensaje({
    required IconData icono,
    required String texto,
    bool conBoton = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: Colors.white54, size: 56),
            const SizedBox(height: 12),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15),
            ),
            if (conBoton) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _recargar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3FA9F5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
