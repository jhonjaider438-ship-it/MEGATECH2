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
  bool ocultarConfirmacion = true;


  Future<void> verificar() async {

    final codigo = codigoController.text.trim();
    final nuevaContrasena =
        nuevaContrasenaController.text;
    final confirmarContrasena =
        confirmarContrasenaController.text;


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


    // Validar que sean 6 números
    if (codigo.length != 6 ||
        int.tryParse(codigo) == null) {

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


    // Validar confirmación
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


    // Verificar que coincidan
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


      // CONTRASEÑA ACTUALIZADA
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {

          return AlertDialog(
            backgroundColor:
                const Color(0xFF10243F),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(25),
              side: const BorderSide(
                color: Color(0xFF00D2FF),
                width: 1.5,
              ),
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  width: 80,
                  height: 80,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFF00C6FF),
                        Color(0xFF0072FF),
                      ],
                    ),
                  ),

                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  '¡Contraseña actualizada!',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  respuesta['message'] ??
                      'Tu contraseña fue actualizada correctamente.',
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.of(context)
                          .pop();

                      Navigator.of(context)
                          .pop();

                    },

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                              0xFF0072FF),

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                    ),

                    child: const Text(
                      'Volver al inicio de sesión',

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );


    } catch (e) {

      if (!mounted) return;

      setState(() {
        cargando = false;
      });


      // CÓDIGO INCORRECTO
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString()
                .replaceFirst(
                    'Exception: ', ''),
          ),

          backgroundColor:
              Colors.redAccent,

          behavior:
              SnackBarBehavior.floating,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12),
          ),
        ),
      );
    }
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

        decoration:
            const BoxDecoration(

          gradient:
              LinearGradient(

            begin:
                Alignment.topCenter,

            end:
                Alignment.bottomCenter,

            colors: [

              Color(0xFF0F2B48),

              Color(0xFF0B1928),

              Color(0xFF050B12),
            ],
          ),
        ),

        child: SafeArea(

          child: SingleChildScrollView(

            padding:
                const EdgeInsets.all(24),

            child: Column(

              children: [

                const SizedBox(height: 15),


                // BOTÓN ATRÁS
                Align(
                  alignment:
                      Alignment.centerLeft,

                  child: InkWell(

                    onTap: () =>
                        Navigator.pop(context),

                    borderRadius:
                        BorderRadius.circular(14),

                    child: Container(

                      width: 50,
                      height: 50,

                      decoration:
                          BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(
                                14),

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
                        size: 27,
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 40),


                // ICONO
                Container(

                  width: 85,
                  height: 85,

                  decoration:
                      BoxDecoration(

                    shape:
                        BoxShape.circle,

                    gradient:
                        const LinearGradient(

                      colors: [

                        Color(0xFF00C6FF),

                        Color(0xFF0072FF),
                      ],
                    ),
                  ),

                  child: const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 45,
                  ),
                ),


                const SizedBox(height: 20),


                const Text(
                  'Verificación de seguridad',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),


                const SizedBox(height: 10),


                Text(
                  'Hemos enviado un código de 6 dígitos a:',
                  textAlign:
                      TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),


                const SizedBox(height: 5),


                Text(
                  widget.correo,

                  textAlign:
                      TextAlign.center,

                  style: const TextStyle(
                    color: Color(0xFF29B6F6),
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),


                const SizedBox(height: 30),


                // TARJETA
                Container(

                  padding:
                      const EdgeInsets.all(24),

                  decoration:
                      BoxDecoration(

                    color:
                        const Color(0xFF0D223A)
                            .withValues(
                                alpha: 0.7),

                    borderRadius:
                        BorderRadius.circular(
                            28),

                    border:
                        Border.all(

                      color:
                          const Color(
                              0xFF00D2FF),

                      width: 1.5,
                    ),
                  ),

                  child: Column(

                    children: [

                      // CÓDIGO
                      const Align(
                        alignment:
                            Alignment.centerLeft,

                        child: Text(
                          'Código de verificación',

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
                            codigoController,

                        keyboardType:
                            TextInputType.number,

                        maxLength: 6,

                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 7,
                        ),

                        decoration:
                            InputDecoration(

                          counterText: '',

                          filled: true,

                          fillColor:
                              const Color(
                                  0xFFD3D3D3),

                          hintText:
                              '000000',

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                                    16),

                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),


                      const SizedBox(height: 20),


                      // NUEVA CONTRASEÑA
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


                      TextField(

                        controller:
                            nuevaContrasenaController,

                        obscureText:
                            ocultarNueva,

                        style:
                            const TextStyle(
                          color: Colors.black,
                        ),

                        decoration:
                            InputDecoration(

                          filled: true,

                          fillColor:
                              const Color(
                                  0xFFD3D3D3),

                          suffixIcon:
                              IconButton(

                            icon: Icon(
                              ocultarNueva
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),

                            onPressed: () {

                              setState(() {

                                ocultarNueva =
                                    !ocultarNueva;

                              });
                            },
                          ),

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                                    16),

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

                        style:
                            const TextStyle(
                          color: Colors.black,
                        ),

                        decoration:
                            InputDecoration(

                          filled: true,

                          fillColor:
                              const Color(
                                  0xFFD3D3D3),

                          suffixIcon:
                              IconButton(

                            icon: Icon(
                              ocultarConfirmacion
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                                    16),

                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),


                      const SizedBox(height: 30),


                      // BOTÓN
                      SizedBox(

                        width:
                            double.infinity,

                        height: 52,

                        child:
                            Container(

                          decoration:
                              BoxDecoration(

                            borderRadius:
                                BorderRadius.circular(
                                    25),

                            gradient:
                                const LinearGradient(

                              colors: [

                                Color(0xFF00C6FF),

                                Color(0xFF0072FF),
                              ],
                            ),
                          ),

                          child:
                              ElevatedButton(

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
                                    BorderRadius.circular(
                                        25),
                              ),
                            ),

                            child:
                                cargando

                                    ? const SizedBox(

                                        width: 25,
                                        height: 25,

                                        child:
                                            CircularProgressIndicator(
                                          color:
                                              Colors.white,
                                          strokeWidth:
                                              2,
                                        ),
                                      )

                                    : const Text(
                                        'Actualizar contraseña',

                                        style:
                                            TextStyle(
                                          color:
                                              Colors.black,
                                          fontSize:
                                              16,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 25),


                const Text(
                  'Por seguridad, el código tiene una duración limitada.',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
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