import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:olx/model/anuncio.dart';

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

  Future<void> uploadImagem(List<File> imagens, String idAnuncio) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference raiz = storage.ref();
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    for (var img in imagens) {
      Reference arquivo =
          raiz.child("meus_anuncios").child(idAnuncio).child("$nomeImagem.jpg");
      await arquivo.putFile(img);
      String urlImagem = await arquivo.getDownloadURL();
      print(urlImagem);
    }
  }
}
