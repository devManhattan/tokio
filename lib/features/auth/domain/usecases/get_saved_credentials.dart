import '../entities/saved_credentials.dart';
import '../repositories/credentials_repository.dart';

class GetSavedCredentials {
  const GetSavedCredentials(this._credentialsRepository);

  final CredentialsRepository _credentialsRepository;

  Future<SavedCredentials?> call() => _credentialsRepository.read();
}
