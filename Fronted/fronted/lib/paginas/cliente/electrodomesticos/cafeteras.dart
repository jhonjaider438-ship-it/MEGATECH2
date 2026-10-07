import 'package:flutter/material.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/paginas/cliente/components/menu.dart';

class Cafeteras extends StatefulWidget {
  const Cafeteras({super.key});

  @override
  State<Cafeteras> createState() => _CafeterasState();
}

class _CafeterasState extends State<Cafeteras> {
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
