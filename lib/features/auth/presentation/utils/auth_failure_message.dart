import '../../domain/failures/auth_failure.dart';

extension AuthFailureMessage on AuthFailure {
  String get message {
    return switch (type) {
      AuthFailureType.invalidCredentials => 'CPF ou senha inválidos',
      AuthFailureType.cpfAlreadyInUse => 'Já existe uma conta com este CPF',
      AuthFailureType.cpfNotFound => 'CPF não encontrado',
      AuthFailureType.emailAlreadyInUse => 'Este e-mail já está em uso',
      AuthFailureType.invalidEmail => 'E-mail inválido',
      AuthFailureType.weakPassword => 'A senha é muito fraca',
      AuthFailureType.network =>
        'Sem conexão. Verifique sua internet e tente novamente',
      AuthFailureType.tooManyRequests =>
        'Muitas tentativas. Aguarde um pouco e tente novamente',
      AuthFailureType.unknown => 'Não foi possível concluir. Tente novamente',
    };
  }
}
