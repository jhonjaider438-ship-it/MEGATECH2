import 'package:flutter/material.dart';

import '../../model/codigoverificacion.dart';
import '../../service/recuperapass.dart';

class VerificarCodigo extends StatefulWidget {
  final String correo;

  const VerificarCodigo({
    super.key,
    required this.correo,
  });

  @override
  State<VerificarCodigo> createState() =>
      _VerificarCodigoState();
}

class _VerificarCodigoState
    extends State<VerificarCodigo> {

  final TextEditingController codigoController =
      TextEditingController();

  final TextEditingController nuevaContrasenaController =
      TextEditingController();

  final TextEditingController confirmarContrasenaController =
      TextEditingController();

  final RecuperarService recuperarService =
      RecuperarService();

  bool cargando = false;
  bool ocultarNueva = true;
  bool ocultarConfirmar = true;

  Future<void> verificar() async {

    final codigo = codigoController.text.trim();
    final nuevaContrasena =
        nuevaContrasenaController.text.trim();

    final confirmar =
        confirmarContrasenaController.text.trim();

    if (codigo.isEmpty ||
        nuevaContrasena.isEmpty ||
        confirmar.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor complete todos los campos',
          ),
        ),
      );

      return;
    }

    if (codigo.length != 6) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El código debe tener 6 dígitos',
          ),
        ),
      );

      return;
    }

    if (nuevaContrasena != confirmar) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Las contraseñas no coinciden',
          ),
        ),
      );

      return;
    }

    if (nuevaContrasena.length < 6) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La contraseña debe tener mínimo 6 caracteres',
          ),
        ),
      );

      return;
    }

    setState(() {
      cargando = true;
    });

    try {

      final verificarCodigoModel =
          VerificarCodigoModel(
        correo: widget.correo,
        codigo: codigo,
        nuevacontrasena: nuevaContrasena,
      );

      final respuesta =
          await recuperarService.verificarCodigo(
        verificarCodigoModel,
      );

      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      mostrarExito(
        respuesta['message'] ??
            'Contraseña actualizada correctamente',
      );

    } catch (e) {

      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  void mostrarExito(String mensaje) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        return AlertDialog(
          backgroundColor: const Color(0xFF10243F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                  ),
                ),

                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 45,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '¡Contraseña actualizada!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 48,

                child: ElevatedButton(
                  onPressed: () {

                    Navigator.of(context).pop();

                    Navigator.of(context).pop();

                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF00AEEF),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text(
                    'Volver al inicio de sesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
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

        decoration: const BoxDecoration(

          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Color(0xFF0F2B48),
              Color(0xFF0B1928),
              Color(0xFF050B12),
            ],
          ),
        ),

        child: SafeArea(

          child: SingleChildScrollView(

            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),

            child: Column(

              children: [

                Align(
                  alignment: Alignment.centerLeft,

                  child: InkWell(

                    onTap: () {
                      Navigator.pop(context);
                    },

                    borderRadius:
                        BorderRadius.circular(14),

                    child: Container(
                      width: 50,
                      height: 50,

                      decoration: BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(14),

                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xFF00C6FF),
                            Color(0xFF0072FF),
                          ],
                        ),
                      ),

                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Container(

                  padding:
                      const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color:
                        const Color(0xFF0D223A),

                    borderRadius:
                        BorderRadius.circular(28),

                    border: Border.all(
                      color:
                          const Color(0xFF00D2FF),
                      width: 1.5,
                    ),
                  ),

                  child: Column(

                    children: [

                      Container(

                        width: 75,
                        height: 75,

                        decoration:
                            const BoxDecoration(

                          shape: BoxShape.circle,

                          gradient:
                              LinearGradient(
                            colors: [
                              Color(0xFF00C6FF),
                              Color(0xFF0072FF),
                            ],
                          ),
                        ),

                        child: const Icon(
                          Icons.verified_user,
                          color: Colors.white,
                          size: 40,
                        ),
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
                        'Hemos enviado un código de 6 dígitos a tu correo electrónico.',
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

                      campo(
                        controller: codigoController,
                        label: 'Código de verificación',
                        icon: Icons.pin,
                        keyboardType:
                            TextInputType.number,
                      ),

                      const SizedBox(height: 18),

                      campo(
                        controller:
                            nuevaContrasenaController,
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
                              ocultarNueva =
                                  !ocultarNueva;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      campo(
                        controller:
                            confirmarContrasenaController,
                        label:
                            'Confirmar contraseña',
                        icon: Icons.lock_outline,
                        obscureText:
                            ocultarConfirmar,

                        suffixIcon: IconButton(
                          icon: Icon(
                            ocultarConfirmar
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black54,
                          ),

                          onPressed: () {

                            setState(() {
                              ocultarConfirmar =
                                  !ocultarConfirmar;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(

                        width: double.infinity,
                        height: 52,

                        decoration:
                            BoxDecoration(

                          borderRadius:
                              BorderRadius.circular(25),

                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFF00C6FF),
                              Color(0xFF0072FF),
                            ],
                          ),
                        ),

                        child: ElevatedButton(

                          onPressed:
                              cargando
                                  ? null
                                  : verificar,

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                Colors.transparent,

                            shadowColor:
                                Colors.transparent,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25),
                            ),
                          ),

                          child: cargando

                              ? const SizedBox(
                                  width: 25,
                                  height: 25,

                                  child:
                                      CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )

                              : const Text(
                                  'Verificar y actualizar',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

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
        ),
      ),
    );
  }

  Widget campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {

    return TextField(

      controller: controller,

      obscureText: obscureText,

      keyboardType: keyboardType,

      style: const TextStyle(
        color: Colors.black,
      ),

      decoration: InputDecoration(

        labelText: label,

        prefixIcon: Icon(
          icon,
          color: Colors.black54,
        ),

        suffixIcon: suffixIcon,

        filled: true,

        fillColor:
            const Color(0xFFD3D3D3),

        border: OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(16),

          borderSide:
              BorderSide.none,
        ),

        focusedBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(16),

          borderSide:
              const BorderSide(
            color: Color(0xFF00C6FF),
            width: 2,
          ),
        ),
      ),
    );
  }
}