import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Controller {
  Future<void> cadastrar(String email, String senha) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((value) {});
  }

  Future<void> logar(String email, String senha) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((value) {});
  }

  Future<void> deslogar() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.signOut();
  }

  Future<List<String>> uploadImagem(
      List<File> imagens, String idAnuncio) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> urls = [];
    Reference raiz = storage.ref();

    for (var img in imagens) {
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      Reference arquivo =
          raiz.child("meus_anuncios").child(idAnuncio).child("$nomeImagem.jpg");
      await arquivo.putFile(img);
      String nomeUrl = await arquivo.getDownloadURL();
      urls.add(nomeUrl);
    }
    return urls;
  }

  Future<void> salvarDadosAnuncios(Map<String, dynamic> map) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus_anuncios")
        .doc(user.uid)
        .collection("anuncios")
        .doc(map["id"])
        .set(map);
  }
}
