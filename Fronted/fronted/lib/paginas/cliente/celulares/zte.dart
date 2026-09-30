import 'package:flutter/material.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/paginas/cliente/components/menu.dart';

class Zte extends StatefulWidget {
  const Zte({super.key});

  @override
  State<Zte> createState() => _ZteState();
}

class _ZteState extends State<Zte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // el fondo llega hasta arriba
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // color del icono ☰
      ),
      drawer: const Menu(),
      body: Fondo(child: SingleChildScrollView()),
    );
  }
}
