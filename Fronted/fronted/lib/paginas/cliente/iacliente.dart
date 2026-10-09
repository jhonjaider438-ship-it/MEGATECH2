import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fronted/components/login/botondevolver.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/paginas/admin/widets.dart/IA/barrera.dart';
import 'package:fronted/paginas/admin/widets.dart/IA/chadborbuja.dart';
import 'package:fronted/service/iacliente.dart';
import 'package:google_fonts/google_fonts.dart';

const String _kSesionChatClienteKey = 'sesion_chat_cliente_id';

class Iacliente extends StatefulWidget {
  const Iacliente({super.key});

  @override
  State<Iacliente> createState() => _IaclienteState();
}

class _IaclienteState extends State<Iacliente> {
  final IaClienteService _iaService = IaClienteService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<MensajeChat> _mensajes = [];
  String? _sesionId;
  bool _cargando = false;
  bool _cargandoHistorial = true;

  @override
  void initState() {
    super.initState();
    _restaurarSesion();
  }

  /// Si ya había una sesión guardada en este dispositivo, recupera
  /// el historial desde el backend para repoblar el chat.
  Future<void> _restaurarSesion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sesionGuardada = prefs.getString(_kSesionChatClienteKey);

      if (sesionGuardada != null && sesionGuardada.isNotEmpty) {
        final historial = await _iaService.obtenerHistorial(sesionGuardada);
        if (!mounted) return;
        setState(() {
          _sesionId = sesionGuardada;
          _mensajes.addAll(historial);
        });
        _scrollAlFinal();
      }
    } catch (e) {
      // Si falla (ej. sin internet) se inicia un chat nuevo.
      debugPrint('No se pudo restaurar el historial del chat: $e');
    } finally {
      if (mounted) {
        setState(() => _cargandoHistorial = false);
      }
    }
  }

  Future<void> _guardarSesionId(String sesionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSesionChatClienteKey, sesionId);
  }

  Future<void> _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _cargando) return;

    setState(() {
      _mensajes.add(MensajeChat(emisor: 'user', mensaje: texto));
      _cargando = true;
      _controller.clear();
    });
    _scrollAlFinal();

    try {
      final data = await _iaService.enviarMensaje(
        mensaje: texto,
        sesionId: _sesionId,
      );
      if (!mounted) return;

      final nuevoSesionId = data['sesionId'] as String?;

      setState(() {
        _sesionId = nuevoSesionId;
        _mensajes.add(
          MensajeChat(emisor: 'bot', mensaje: data['respuesta'] ?? ''),
        );
      });

      if (nuevoSesionId != null && nuevoSesionId.isNotEmpty) {
        await _guardarSesionId(nuevoSesionId);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajes.add(
          MensajeChat(
            emisor: 'bot',
            mensaje:
                'Ocurrió un error: ${e.toString().replaceAll('Exception: ', '')}',
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
        _scrollAlFinal();
      }
    }
  }

  void _scrollAlFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Fondo(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Botondevolver(),
                    const SizedBox(width: 16),
                    Text(
                      'Asistente IA',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _cargandoHistorial
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white54),
                      )
                    : _mensajes.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Hola, pregúntame lo que necesites\nsobre productos, pedidos o el negocio.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: _mensajes.length,
                        itemBuilder: (context, index) {
                          final m = _mensajes[index];
                          return BurbujaMensaje(
                            mensaje: m.mensaje,
                            esUsuario: m.emisor == 'user',
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: BarraEntradaChat(
                  controller: _controller,
                  onEnviar: _enviarMensaje,
                  cargando: _cargando,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
