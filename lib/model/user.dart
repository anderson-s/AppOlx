class Usuario {
  String _uid;
  String _email;
  String _senha;

  Usuario(this._uid, this._email, this._senha);

  String get uid {
    return _uid;
  }

  set sUid(String uid) {
    _uid = uid;
  }

  String get email {
    return _email;
  }

  set sEmail(String email) {
    _email = email;
  }

  String get senha {
    return _senha;
  }

  set sSenha(String senha) {
    _senha = senha;
  }
}
