import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx/model/anuncio.dart';
import 'package:olx/view/components/itens_anuncios.dart';

class MyWidget extends StatefulWidget {
  final Stream<dynamic> controller;
  const MyWidget({super.key, required this.controller});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  StreamBuilder build(BuildContext context) {
    return StreamBuilder(
      stream: widget.controller,
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
            }

            QuerySnapshot? querySnapshot = snapshot.data;
            if (querySnapshot!.docs.isNotEmpty) {
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
        }
        // return Container();
      },
    );
  }
}
