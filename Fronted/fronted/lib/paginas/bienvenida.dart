import 'package:flutter/material.dart';

class bienvenida extends StatefulWidget {
  const bienvenida({super.key});

  @override
  State<bienvenida> createState() => _bienvenidaState();
}

class _bienvenidaState extends State<bienvenida> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Bienvenido a Megatech '),
          Text(
            'En Megatech 2 te ofrecemos lo mejor en tecnología con una experiencia rápida, segura y confiable para que compres sin complicaciones.',
          ),
        ],
      ),
    );
  }
}
