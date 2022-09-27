class AuthException implements Exception {
  
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail ja foi cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Bloqueamos as tentativas de registro deste dispositivo pelo comportamento suspeito. Tente novamente em alguns minutos.',
    'EMAIL_NOT_FOUND': 'Este e-mail não esta associado a nenhum usuario.',
    'INVALID_PASSWORD': 'Senha invalida/incorreta.',
    'USER_DISABLED': 'Usuario desabilitado pelo administrador.',
  };

  final String key;
  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ??
        'Ocorreu um erro no processo de autentificação. Tente novamente em alguns minutos.';
  }
}
