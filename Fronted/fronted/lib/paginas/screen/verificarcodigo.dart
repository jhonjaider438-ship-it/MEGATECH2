import 'package:flutter/material.dart';

import '../../model/codigoverificacion.dart';
import '../../service/recuperapass.dart';

import '../../components/codigo_verifi/dialogoexito.dart';
import '../../components/codigo_verifi/iconocirculodegradado.dart';

import '../../components/rescuperar_contra/BotonRegresarDegradado.dart';
import '../../components/rescuperar_contra/CampoTexto.dart';
import '../../components/rescuperar_contra/TarjetaFormulario.dart';

class VerificarCodigo extends StatefulWidget {
  final String correo;

  const VerificarCodigo({super.key, required this.correo});

  @override
  State<VerificarCodigo> createState() => _VerificarCodigoState();
}

class _VerificarCodigoState extends State<VerificarCodigo> {
  final TextEditingController codigoController = TextEditingController();

  final TextEditingController nuevaContrasenaController =
      TextEditingController();

  final TextEditingController confirmarContrasenaController =
      TextEditingController();

  final RecuperarService recuperarService = RecuperarService();

  bool cargando = false;
  bool ocultarNueva = true;
  bool ocultarConfirmar = true;

  Future<void> verificar() async {
    final codigo = codigoController.text.trim();
    final nuevaContrasena = nuevaContrasenaController.text.trim();
    final confirmar = confirmarContrasenaController.text.trim();

    if (codigo.isEmpty || nuevaContrasena.isEmpty || confirmar.isEmpty) {
      _mostrarMensaje('Por favor complete todos los campos');
      return;
    }

    if (codigo.length != 6) {
      _mostrarMensaje('El código debe tener 6 dígitos');
      return;
    }

    if (nuevaContrasena != confirmar) {
      _mostrarMensaje('Las contraseñas no coinciden');
      return;
    }

    if (nuevaContrasena.length < 6) {
      _mostrarMensaje('La contraseña debe tener mínimo 6 caracteres');
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final modelo = VerificarCodigoModel(
        correo: widget.correo,
        codigo: codigo,
        nuevacontrasena: nuevaContrasena,
      );

      final respuesta = await recuperarService.verificarCodigo(modelo);

      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      _mostrarExito(
        respuesta['message'] ?? 'Contraseña actualizada correctamente',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _mostrarExito(String mensaje) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DialogoExito(mensaje: mensaje);
      },
    );
  }

  @override
  void dispose() {
    codigoController.dispose();
    nuevaContrasenaController.dispose();
    confirmarContrasenaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2B48), Color(0xFF0B1928), Color(0xFF050B12)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: Column(
                    children: [
                      BotonRegresarDegradado(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 35),

                      TarjetaFormulario(
                        child: Column(
                          children: [
                            const IconoCirculoDegradado(
                              icono: Icons.verified_user,
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Verificación de código',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'Hemos enviado un código de 6 dígitos '
                              'a tu correo electrónico.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              widget.correo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF29B6F6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 30),

                            CampoTexto(
                              controller: codigoController,
                              label: 'Código de verificación',
                              icon: Icons.pin,
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 18),

                            CampoTexto(
                              controller: nuevaContrasenaController,
                              label: 'Nueva contraseña',
                              icon: Icons.lock,
                              obscureText: ocultarNueva,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  ocultarNueva
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  setState(() {
                                    ocultarNueva = !ocultarNueva;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 18),

                            CampoTexto(
                              controller: confirmarContrasenaController,
                              label: 'Confirmar contraseña',
                              icon: Icons.lock_outline,
                              obscureText: ocultarConfirmar,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  ocultarConfirmar
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  setState(() {
                                    ocultarConfirmar = !ocultarConfirmar;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 30),

                            _botonVerificar(),

                            const SizedBox(height: 20),

                            const Text(
                              'El código tiene una duración de 15 minutos.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _botonVerificar() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
        ),
      ),
      child: ElevatedButton(
        onPressed: cargando ? null : verificar,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: cargando
            ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Verificar y actualizar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
