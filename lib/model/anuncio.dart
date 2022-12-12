import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  late String _id;
  late String _estado;
  late String _categoria;
  late String _titulo;
  late String _preco;
  late String _telefone;
  late String _descricao;
  late List<String> _fotos;
  Anuncio() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference colecao = db.collection("MeusAnuncios");
    _id = colecao.doc().id;
    _fotos = [];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": _id,
      "estado": _estado,
      "categoria": _categoria,
      "titulo": _titulo,
      "preco": _preco,
      "telefone": _telefone,
      "descricao": _descricao,
      "fotos": _fotos,
    };
    return map;
  }

  String get id {
    return _id;
  }

  set sId(String id) {
    _id = id;
  }

  String get estado {
    return _estado;
  }

  set sEstado(String estado) {
    _estado = estado;
  }

  String get categoria {
    return _categoria;
  }

  set scategoria(String categoria) {
    _categoria = categoria;
  }

  String get titulo {
    return _titulo;
  }

  set stitulo(String titulo) {
    _titulo = titulo;
  }

  String get preco {
    return _preco;
  }

  set sPreco(String preco) {
    _preco = preco;
  }

  String get telefone {
    return _telefone;
  }

  set sTelefone(String telefone) {
    _telefone = telefone;
  }

  String get descricao {
    return _descricao;
  }

  set sDescricao(String descricao) {
    _descricao = descricao;
  }

  List<String> get fotos {
    return _fotos;
  }

  set sFotos(List<String> fotos) {
    _fotos = fotos;
  }
}
