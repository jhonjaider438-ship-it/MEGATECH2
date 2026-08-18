import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service/apiuser.dart';
import '../service/confiuser.dart';
import '../paginas/homeclie.dart';
import '../paginas/homeemple.dart';
import '../paginas/homeadmin.dart';
import '../model/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  final userservice _userService = userservice();

  Future<void> iniciarSesion() async {
    try {

      final respuesta = await _userService.loginUsuario(
        correoController.text.trim(),
        contrasenaController.text,
      );

      final usuario = usermodel.fromJson(respuesta['usuario']);

      if (!mounted) return;

      if (usuario.rol == 'Cliente') {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homeclie(),
          ),
        );

      } else if (usuario.rol == 'Empleado') {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homeemple(),
          ),
        );

      } else if (usuario.rol == 'Admin') {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homeadmin(),
          ),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rol no reconocido'),
          ),
        );
      }

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // FONDO
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF173A55),
              Color(0xFF0B202E),
              Color(0xFF06141D),
            ],
          ),
        ),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            children: [
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 54,
                    height: 43,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF29B6F6),
                          Color(0xFF0288D1),
                        ],
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                        child: const Icon(
                        Icons.undo,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                      ),
                    )
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // targeta del login
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 18
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF202A39),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color:  const Color(0xFF20BFFF),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 65,
                    ),
                    // titulo
                    const SizedBox(height: 8),
                    Text(
                      'Bienvenido de vuelta',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // subtitulo
                    Text(
                      'Inicia sesion en tu cuenta de megatech 2',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // correo electronico
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Correo electronico',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: correoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // contraseña
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contraseña',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: contrasenaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // parte de recordarme y registrase 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                            ),
                            Text(
                              'Recordarme',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          '¿Olvidaste la contraseña?',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF2196F3),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // boton de iniciar sesion
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: iniciarSesion,
                      child: Container(
                      width: 185,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF29B6F6),
                            Color(0xFF0288D1),
                          ],
                        ),
                      ),
                      child: Center(
                      child: Text(
                        'Iniciar sesion',
                        style: GoogleFonts.acme(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ),
                    ),
                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '¿No tienes cuenta?',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          'Registrate aquí',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF2196F3),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 16,
                        ),

                        const SizedBox(width: 5),

                        Flexible(
                          child: Text(
                            'Tus datos estan protegidos con nivel de incriptacion empresarial',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 8,
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
          ),
          ),
      ),
    );
  }
}