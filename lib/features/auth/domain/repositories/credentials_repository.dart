import '../entities/saved_credentials.dart';

abstract class CredentialsRepository {
  Future<SavedCredentials?> read();

  Future<void> save(SavedCredentials credentials);

  Future<void> clear();
}
