import 'package:flutter/material.dart';

class TelaAnuncios extends StatefulWidget {
  const TelaAnuncios({super.key});

  @override
  State<TelaAnuncios> createState() => _TelaAnunciosState();
}

class _TelaAnunciosState extends State<TelaAnuncios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus anúncios"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {Navigator.pushNamed(context, "/novo_anuncio");}, child: const Icon(Icons.add),),
      body: Container(
        child: Column(),
      ),
    );
  }
}
