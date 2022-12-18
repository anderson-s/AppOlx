import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/controller/controller.dart';
import 'package:olx/model/anuncio.dart';
import 'package:olx/view/components/drop_itens.dart';
import 'package:olx/view/components/itens_anuncios.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  List<String> itensMenu = ["Menu 1", "Menu 2"];
  String dropdownValueEstados = "null";
  String dropdownValueCategoria = "Categoria";
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

  final _controller = StreamController<QuerySnapshot>.broadcast();
  carregar() async {
    Stream<QuerySnapshot> stream = await Controller().carregarAnuncio(0);
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _escolha(String item) {
    switch (item) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus_anuncios");
        break;
      case "Deslogar":
        Navigator.pushNamed(context, "login");
        Controller().deslogar();
        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "login");
        break;
    }
  }

  @override
  void initState() {
    verLogin();
    carregar();
    super.initState();
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
                setState(() {
                  dropdownValueEstados = value!;
                });
              }, (p0) => null, 1, dropdownValueEstados)),
              Container(
                color: Colors.grey[200],
                width: 2,
                height: 60,
              ),
              Expanded(
                  child: ConfiguracoesItensDrop().retornarDropCategorias(
                      (p0) => null, 1, dropdownValueCategoria, (String? value) {
                setState(() {
                  dropdownValueCategoria = value!;
                });
              }))
            ],
          ),
          StreamBuilder(
            stream: _controller.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      children: const [
                        Text("Carregando anúncios"),
                        CircularProgressIndicator()
                      ],
                    ),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Container(
                      padding: const EdgeInsets.all(25),
                      child: const Text(
                        "Erro ao tentar carregar os anúncios :(",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, index) {
                          List<DocumentSnapshot> anuncios =
                              querySnapshot.docs.toList();
                          DocumentSnapshot docsSnapshot = anuncios[index];
                          Anuncio anuncio = Anuncio.carregarDados(docsSnapshot);
                          return ItensAnuncios(anuncio: anuncio);
                        },
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(25),
                      child: const Text(
                        "Nenhum anúncio! :( ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                // if (querySnapshot.docs.isEmpty) {

                // }
              }
              // return Container();
            },
          )
        ],
      ),
    );
  }
}
