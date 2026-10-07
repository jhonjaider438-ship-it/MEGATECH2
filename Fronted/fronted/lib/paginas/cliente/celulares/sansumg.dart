import 'package:flutter/material.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/paginas/cliente/components/menu.dart';

class Sansumg extends StatefulWidget {
  const Sansumg({super.key});

  @override
  State<Sansumg> createState() => _SansumgState();
}

class _SansumgState extends State<Sansumg> {
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
