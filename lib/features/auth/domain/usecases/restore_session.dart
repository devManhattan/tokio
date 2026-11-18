import '../repositories/auth_repository.dart';
import '../repositories/credentials_repository.dart';

class RestoreSession {
  const RestoreSession(this._authRepository, this._credentialsRepository);

  final AuthRepository _authRepository;
  final CredentialsRepository _credentialsRepository;

  Future<void> call() async {
    final credentials = await _credentialsRepository.read();
    if (credentials == null) {
      await _authRepository.signOut();
    }
  }
}
