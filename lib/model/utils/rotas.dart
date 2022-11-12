import 'package:flutter/material.dart';
import 'package:olx/view/tela_inicio.dart';
import 'package:olx/view/tela_login.dart';

class Rotas {
  static Route<dynamic> gerar(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const TelaInicio());
      case "login":
        return MaterialPageRoute(builder: (_) => const TelaLogin());
      default:
        return _errorRota();
    }
  }

  static Route<dynamic> _errorRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada"),
        ),
      );
    });
  }
}
