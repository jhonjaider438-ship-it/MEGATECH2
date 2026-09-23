import 'package:flutter/material.dart';
import 'package:fronted/components/login/botonaaccionprincipal.dart';
import 'package:fronted/components/login/botondevolver.dart';
import 'package:fronted/components/login/contenedorformulario.dart';
import 'package:fronted/components/login/datosprotejidos.dart';
import 'package:fronted/components/login/encabesado.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/components/login/leertexto.dart';
import 'package:fronted/components/login/notienesregister.dart';
import 'package:fronted/paginas/correodestacado.dart';
import 'package:fronted/paginas/screen/register.dart';
import 'package:fronted/service/confiuser.dart';

/// Pantalla para confirmar el correo con el código de 6 dígitos que se
/// envía al registrarse. Al verificar correctamente, pasa a la pantalla
/// de "registro exitoso".
class VerificarCuenta extends StatefulWidget {
  final String correo;

  const VerificarCuenta({super.key, required this.correo});

  @override
  State<VerificarCuenta> createState() => _VerificarCuentaState();
}

class _VerificarCuentaState extends State<VerificarCuenta> {
  final codigoController = TextEditingController();
  final Userservice _userService = Userservice();
  bool cargando = false;

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _verificar() async {
    final codigo = codigoController.text.trim();

    if (codigo.isEmpty) {
      _mensaje('Ingresa el código de verificación');
      return;
    }
    if (codigo.length != 6) {
      _mensaje('El código debe tener 6 dígitos');
      return;
    }

    setState(() => cargando = true);
    try {
      await _userService.verificarCuenta(widget.correo, codigo);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Register()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => cargando = false);
      _mensaje(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _reenviar() async {
    try {
      final respuesta = await _userService.reenviarCodigo(widget.correo);
      if (!mounted) return;
      _mensaje(respuesta['message'] ?? 'Código reenviado correctamente');
    } catch (e) {
      if (!mounted) return;
      _mensaje(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Fondo(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Botondevolver()],
                ),
                const SizedBox(height: 20),

                Contenedorformulario(
                  child: Column(
                    children: [
                      const Encabesado(
                        icon: Icons.verified_user_outlined,
                        title: 'Verifica tu cuenta',
                        subtitle:
                            'Hemos enviado un codigo de 6 digitos a tu correo electronico',
                      ),
                      const SizedBox(height: 6),
                      Correodestacado(text: widget.correo),
                      const SizedBox(height: 28),

                      Leertexto(
                        label: 'Codigo de verificacion',
                        controller: codigoController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      Botonaaccionprincipal(
                        text: cargando ? 'Verificando...' : 'Verificar cuenta',
                        onTap: cargando ? () {} : _verificar,
                        width: 250,
                      ),
                      const SizedBox(height: 25),

                      Notienesregister(
                        question: '¿No recibiste el codigo?',
                        actionText: 'Reenviar codigo',
                        onTap: _reenviar,
                      ),
                      const SizedBox(height: 17),

                      const Datosprotejidos(
                        text: 'El codigo tiene una duracion de 15 minutos',
                      ),
                    ],
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