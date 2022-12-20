import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx/controller/controller.dart';
import 'package:olx/model/anuncio.dart';
import 'package:olx/view/components/itens_anuncios.dart';

class TelaAnuncios extends StatefulWidget {
  const TelaAnuncios({super.key});

  @override
  State<TelaAnuncios> createState() => _TelaAnunciosState();
}

class _TelaAnunciosState extends State<TelaAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Stream<QuerySnapshot>? stream;
  final _carregar = Center(
    child: Column(
      children: const [
        Text("Carregando anúncios"),
        CircularProgressIndicator()
      ],
    ),
  );

  carregar() async {
    stream = await Controller().carregarAnuncio(0);
    stream!.listen(
      (dados) {
        _controller.add(dados);
      },
      onError: (error) => print("O error é: $error"),
    );
  }

  @override
  void initState() {
    carregar();
    super.initState();
  }

  @override
  void dispose() {
    carregar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus anúncios"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/novo_anuncio");
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return _carregar;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Text("Erro ao carregar os dados!");
              }
              QuerySnapshot? querySnapshot = snapshot.data;
              if (querySnapshot!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, index) {
                    List<DocumentSnapshot> anuncios =
                        querySnapshot.docs.toList();
                    DocumentSnapshot docsSnapshot = anuncios[index];
                    Anuncio anuncio = Anuncio.carregarDados(docsSnapshot);
                    return ItensAnuncios(
                      anuncio: anuncio,
                      onPressedRemover: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Confirmar"),
                                content: const Text(
                                    "Deseja realmente excluir o anúncio?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Cancelar",
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Controller().removerAnuncio(anuncio.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Remover",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                    );
                  },
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "Nenhum anúncio! :( ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
