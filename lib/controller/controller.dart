import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:olx/model/utils/exceptions_cadastro.dart';
import 'package:olx/model/utils/exceptions_login.dart';

class Controller {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> cadastrar(String email, String senha) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: senha);
    } on FirebaseAuthException catch (error) {
      throw ExceptionsCadastro(exception: error.code);
    } catch (error) {
      return;
    }
  }

  Future<int?> verlogin() async {
    User? user = firebaseAuth.currentUser;
    if(user?.uid == null){
      return null;
    }else{
      return 0;
    }
  }

  Future<void> logar(String email, String senha) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
    } on FirebaseAuthException catch (error) {
      throw ExceptionsLogin(exception: error.code);
    }
  }

  Future<void> deslogar() async {
    await firebaseAuth
        .signOut()
        .then((value) => print("saiu"))
        .catchError((onError) => print(onError));
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
    User user = firebaseAuth.currentUser!;
    FirebaseFirestore db = FirebaseFirestore.instance;
    //Meus Anuncios
    db
        .collection("meus_anuncios")
        .doc(user.uid)
        .collection("anuncios")
        .doc(map["id"])
        .set(map)
        .then(
      (value) {
        //Anuncios Publicos
        db.collection("anuncios").doc(map["id"]).set(map);
      },
    );
  }

  Future<Stream<QuerySnapshot<Object?>>> carregarAnuncio(int i) async {
    User user = firebaseAuth.currentUser!;
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot>? stream;
    if (user.uid.isNotEmpty) {
      if (i == 0) {
        stream = db
            .collection("meus_anuncios")
            .doc(user.uid)
            .collection("anuncios")
            .snapshots();
      } else {
        stream = db.collection("anuncios").snapshots();
      }
    }

    return stream!;
  }

  Future removerAnuncio(String idAnuncio) async {
    User user = firebaseAuth.currentUser!;
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus_anuncios")
        .doc(user.uid)
        .collection("anuncios")
        .doc(idAnuncio)
        .delete()
        .then((_) {
      db.collection("anuncios").doc(idAnuncio).delete();
    });
  }
}
