class ExceptionsLogin implements Exception {
  final String exception;
  ExceptionsLogin({
    required this.exception,
  });

  static const Map<String, String> errors = {
    "user-not-found": 'E-mail não encontrado!',
    "wrong-password": "Verifique sua senha!",
    "invalid-email": "Este email é inválido!",
  };
  @override
  String toString() {
    return errors[exception] ?? 'Ocorreu um erro no processo de login!';
  }
}
