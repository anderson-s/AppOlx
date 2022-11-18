import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback funcao;
  const BotaoCustomizado(
      {super.key,
      required this.funcao,
      required this.texto,
      this.corTexto = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: funcao,
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        backgroundColor: const MaterialStatePropertyAll(
          Color(0xff9c27b0),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.fromLTRB(32, 16, 32, 16),
        ),
      ),
      child: Text(
        texto,
        style: TextStyle(color: corTexto, fontSize: 20),
      ),
    );
  }
}
