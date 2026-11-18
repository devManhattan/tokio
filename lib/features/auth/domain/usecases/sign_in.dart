import '../entities/saved_credentials.dart';
import '../repositories/auth_repository.dart';
import '../repositories/credentials_repository.dart';

class SignIn {
  const SignIn(this._authRepository, this._credentialsRepository);

  final AuthRepository _authRepository;
  final CredentialsRepository _credentialsRepository;

  Future<void> call({
    required String cpf,
    required String password,
    required bool remember,
  }) async {
    await _authRepository.signIn(cpf: cpf, password: password);
    if (remember) {
      await _credentialsRepository.save(
        SavedCredentials(cpf: cpf, password: password),
      );
    } else {
      await _credentialsRepository.clear();
    }
  }
}
