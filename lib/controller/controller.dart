import 'package:firebase_auth/firebase_auth.dart';

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
        .then((value) {
          print(value.toString());
        });
  }
  Future<void> deslogar() async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.signOut();
  }
}
