import '../repositories/auth_repository.dart';

class SendPasswordReset {
  const SendPasswordReset(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call({required String cpf}) {
    return _authRepository.sendPasswordReset(cpf: cpf);
  }
}
