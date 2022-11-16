import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/controller/controller.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  List<String> itensMenu = ["Menu 1", "Menu 2"];

  Future<void> verLogin() async {
    User? usuarioLogado = FirebaseAuth.instance.currentUser;
    if (usuarioLogado != null) {
      setState(() {
        itensMenu = ["Meus anúncios", "Deslogar"];
      });
    } else {
      setState(() {
        itensMenu = ["Entrar / Cadastrar"];
      });
    }
  }

  _escolha(String item) {
    switch (item) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus_anuncios");
        break;
      case "Deslogar":
        Controller()
            .deslogar()
            .then((value) => Navigator.pushNamed(context, "login"));

        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "login");
        break;
    }
  }

  @override
  void initState() {
    verLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return itensMenu.map(
                (String item) {
                  return PopupMenuItem(
                    value: item,
                    child: Text(item),
                  );
                },
              ).toList();
            },
            onSelected: _escolha,
          ),
        ],
      ),
      body: Container(
        child: const Text("Anúncios"),
      ),
    );
  }
}
