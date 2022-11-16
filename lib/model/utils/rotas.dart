import 'package:flutter/material.dart';
import 'package:olx/view/tela_anuncios.dart';
import 'package:olx/view/tela_inicio.dart';
import 'package:olx/view/tela_login.dart';
import 'package:olx/view/tela_novo_anuncio.dart';

class Rotas {
  static Route<dynamic> gerar(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const TelaInicio());
      case "login":
        return MaterialPageRoute(builder: (_) => const TelaLogin());
      case "/meus_anuncios":
        return MaterialPageRoute(builder: (_) => const TelaAnuncios());
      case "/novo_anuncio":
        return MaterialPageRoute(builder: (_) => const TelaNovoAnuncio());
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
