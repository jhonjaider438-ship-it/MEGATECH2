import 'package:flutter/material.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/paginas/cliente/components/menu.dart';

class CabezotesTc extends StatefulWidget {
  const CabezotesTc({super.key});

  @override
  State<CabezotesTc> createState() => _CabezotesTcState();
}

class _CabezotesTcState extends State<CabezotesTc> {
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
