import 'package:flutter/material.dart';
import 'package:fronted/components/login/fondo.dart';
import 'package:fronted/paginas/cliente/components/menu.dart';

class CabezotesUsb extends StatefulWidget {
  const CabezotesUsb({super.key});

  @override
  State<CabezotesUsb> createState() => _CabezotesUsbState();
}

class _CabezotesUsbState extends State<CabezotesUsb> {
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
