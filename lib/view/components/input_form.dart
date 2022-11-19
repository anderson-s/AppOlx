import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputForm extends StatelessWidget {
  final String nomeCampo;
  final TextInputType tipo;
  final List<TextInputFormatter> formato;
  final String? Function(String?)? validar;
  const InputForm(
      {super.key,
      required this.nomeCampo,
      required this.tipo,
      required this.formato,
      required this.validar,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: formato,
      validator: validar,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: nomeCampo,
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
