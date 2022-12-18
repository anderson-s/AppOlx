class ExceptionsCadastro implements Exception {
  final String exception;
  ExceptionsCadastro({required this.exception});
  static const Map<String, String> errors = {
    "invalid-email": "O endereço de e-mail está formatado incorretamente!",
    "weak-password": "A senha deve ter pelo menos 6 caracteres!",
    "email-already-in-use": "O email já foi cadastrado!",
  };
  @override
  String toString() {
    return errors[exception] ?? 'Ocorreu um erro no processo de cadastro!';
  }
}
