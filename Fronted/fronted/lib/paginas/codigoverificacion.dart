import 'package:flutter/material.dart';
import '../model/codigoverificacion.dart';
import '../service/recuperapass.dart';

class VerificarCodigo extends StatefulWidget {
  final String correo;

  const VerificarCodigo({
    super.key,
    required this.correo,
  });

  @override
  State<VerificarCodigo> createState() => _VerificarCodigoState();
}

class _VerificarCodigoState extends State<VerificarCodigo> {
  final TextEditingController codigoController =
      TextEditingController();

  final TextEditingController nuevaContrasenaController =
      TextEditingController();

  final TextEditingController confirmarContrasenaController =
      TextEditingController();

  final RecuperarService _recuperarService =
      RecuperarService();

  bool cargando = false;
  bool ocultarContrasena = true;
  bool ocultarConfirmacion = true;

  Future<void> verificarCodigo() async {
    final codigo = codigoController.text.trim();
    final nuevaContrasena =
        nuevaContrasenaController.text.trim();
    final confirmarContrasena =
        confirmarContrasenaController.text.trim();

    // Validar código
    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingrese el código de recuperación',
          ),
        ),
      );
      return;
    }

    if (codigo.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El código debe tener 6 números',
          ),
        ),
      );
      return;
    }

    // Validar contraseña
    if (nuevaContrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingrese una nueva contraseña',
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

    // Confirmar contraseña
    if (confirmarContrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Confirme su nueva contraseña',
          ),
        ),
      );
      return;
    }

    if (nuevaContrasena != confirmarContrasena) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Las contraseñas no coinciden',
          ),
        ),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final verificar = VerificarCodigoModel(
        correo: widget.correo,
        codigo: codigo,
        nuevaContrasena: nuevaContrasena,
      );

      final respuesta =
          await _recuperarService.verificarCodigo(
        verificar,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            respuesta['message'] ??
                respuesta['mensaje'] ??
                'Contraseña actualizada correctamente',
          ),
        ),
      );

      // Regresar al login
      await Future.delayed(
        const Duration(seconds: 1),
      );

      if (!mounted) return;

      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;

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
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
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
              vertical: 16,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // BOTÓN REGRESAR
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
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

                const SizedBox(height: 70),

                // TARJETA
                Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),

                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF0D223A)
                            .withValues(
                      alpha: 0.6,
                    ),

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
                      // TÍTULO
                      const Text(
                        'Verificar código',

                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Ingrese el código de 6 dígitos que enviamos a su correo electrónico.',

                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // CORREO
                      Text(
                        widget.correo,

                        textAlign:
                            TextAlign.center,

                        style: const TextStyle(
                          color:
                              Color(0xFF00C6FF),

                          fontSize: 14,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // LABEL CÓDIGO
                      const Align(
                        alignment:
                            Alignment.centerLeft,

                        child: Text(
                          'Código de recuperación',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // CÓDIGO
                      TextField(
                        controller:
                            codigoController,

                        keyboardType:
                            TextInputType.number,

                        maxLength: 6,

                        textAlign:
                            TextAlign.center,

                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 6,
                        ),

                        decoration:
                            InputDecoration(
                          counterText: '',

                          filled: true,

                          fillColor:
                              const Color(
                            0xFFD3D3D3,
                          ),

                          hintText: '000000',

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // LABEL NUEVA CONTRASEÑA
                      const Align(
                        alignment:
                            Alignment.centerLeft,

                        child: Text(
                          'Nueva contraseña',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // NUEVA CONTRASEÑA
                      TextField(
                        controller:
                            nuevaContrasenaController,

                        obscureText:
                            ocultarContrasena,

                        style: const TextStyle(
                          color: Colors.black,
                        ),

                        decoration:
                            InputDecoration(
                          filled: true,

                          fillColor:
                              const Color(
                            0xFFD3D3D3,
                          ),

                          hintText:
                              'Nueva contraseña',

                          suffixIcon:
                              IconButton(
                            icon: Icon(
                              ocultarContrasena
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),

                            onPressed: () {
                              setState(() {
                                ocultarContrasena =
                                    !ocultarContrasena;
                              });
                            },
                          ),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // CONFIRMAR CONTRASEÑA
                      const Align(
                        alignment:
                            Alignment.centerLeft,

                        child: Text(
                          'Confirmar contraseña',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            confirmarContrasenaController,

                        obscureText:
                            ocultarConfirmacion,

                        style: const TextStyle(
                          color: Colors.black,
                        ),

                        decoration:
                            InputDecoration(
                          filled: true,

                          fillColor:
                              const Color(
                            0xFFD3D3D3,
                          ),

                          hintText:
                              'Repita la contraseña',

                          suffixIcon:
                              IconButton(
                            icon: Icon(
                              ocultarConfirmacion
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),

                            onPressed: () {
                              setState(() {
                                ocultarConfirmacion =
                                    !ocultarConfirmacion;
                              });
                            },
                          ),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // BOTÓN
                      Container(
                        width: double.infinity,
                        height: 48,

                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),

                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFF00C6FF),
                              Color(0xFF0072FF),
                            ],
                          ),
                        ),

                        child: ElevatedButton(
                          onPressed: cargando
                              ? null
                              : verificarCodigo,

                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                Colors.transparent,

                            disabledBackgroundColor:
                                Colors.transparent,

                            shadowColor:
                                Colors.transparent,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                24,
                              ),
                            ),
                          ),

                          child: cargando
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,

                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,

                                    color:
                                        Colors.black,
                                  ),
                                )
                              : const Text(
                                  'Cambiar contraseña',

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.black,

                                    fontSize: 16,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    codigoController.dispose();
    nuevaContrasenaController.dispose();
    confirmarContrasenaController.dispose();

    super.dispose();
  }
}