import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx/controller/controller.dart';
import 'package:olx/view/components/drop_itens.dart';
import 'package:olx/view/components/stream.dart';
import 'package:olx/view/tela_login.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  List<String> itensMenu = ["Meus anúncios", "Deslogar"];
  String dropdownValueEstados = "null";
  int valor = 0;
  Stream<QuerySnapshot>? stream;
  String dropdownValueCategoria = "Categoria";

  final _controller = StreamController<QuerySnapshot>.broadcast();
  carregar() async {
    stream = await Controller().carregarAnuncio(1);
    stream!.listen(
      (dados) {
        _controller.add(dados);
      },
      onError: (error) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TelaLogin(),
        ),
      ),
    );
  }

  filtrar() async {
    stream = await Controller()
        .filtrarAnuncios(dropdownValueEstados, dropdownValueCategoria);
    stream!.listen((event) {
      _controller.add(event);
    });
  }

  _escolha(String item) async {
    switch (item) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus_anuncios");
        break;
      case "Deslogar":
        setState(() {
          valor = 1;
          stream = null;
        });
        popUp();
        await Controller().deslogar();
        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "login");
        break;
    }
  }

  @override
  void initState() {
    carregar();
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    carregar().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        automaticallyImplyLeading: false,
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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: ConfiguracoesItensDrop().retornarDropEstados(
                      (String? value) {
                setState(
                  () {
                    dropdownValueEstados = value!;
                    filtrar();
                  },
                );
              }, (p0) => null, 1, dropdownValueEstados)),
              Container(
                color: Colors.grey[200],
                width: 2,
                height: 60,
              ),
              Expanded(
                child: ConfiguracoesItensDrop().retornarDropCategorias(
                  (p0) => null,
                  1,
                  dropdownValueCategoria,
                  (String? value) {
                    setState(
                      () {
                        dropdownValueCategoria = value!;
                        filtrar();
                      },
                    );
                  },
                ),
              )
            ],
          ),
          if (valor == 0) MyWidget(controller: _controller.stream),
        ],
      ),
    );
  }

  popUp() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff9c27b0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        content: Builder(
          builder: (context) {
            final mediaQuery = MediaQuery.of(context);
            return SizedBox(
              height: mediaQuery.size.height * .30,
              width: mediaQuery.size.width * .30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                  AutoSizeText(
                    "Saindo...",
                    style: TextStyle(
                      inherit: false,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      // fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
