import 'package:flutter/material.dart';

class InpuTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType tipo;
  final String nome;
  final bool autofocus;
  final bool oculto;
  const InpuTextFormField({
    super.key,
    required this.controller,
    required this.tipo,
    required this.nome,
    required this.autofocus,
    required this.oculto,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: oculto,
      keyboardType: tipo,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: nome,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      ),
    );
  }
}
