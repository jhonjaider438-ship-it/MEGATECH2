import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarraBusqueda extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  const BarraBusqueda({
    super.key,
    this.controller,
    this.hintText = 'Buscar productos...',
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onSubmitted,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF20BFFF)),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color(0xFF202A39),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF20BFFF), width: 1.5),
          ),
        ),
      ),
    );
  }
}