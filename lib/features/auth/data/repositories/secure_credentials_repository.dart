import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/saved_credentials.dart';
import '../../domain/repositories/credentials_repository.dart';

class SecureCredentialsRepository implements CredentialsRepository {
  SecureCredentialsRepository(this._storage);

  static const _cpfKey = 'saved_cpf';
  static const _passwordKey = 'saved_password';

  final FlutterSecureStorage _storage;

  @override
  Future<SavedCredentials?> read() async {
    try {
      final cpf = await _storage.read(key: _cpfKey);
      final password = await _storage.read(key: _passwordKey);
      if (cpf == null || password == null) return null;
      return SavedCredentials(cpf: cpf, password: password);
    } catch (_) {
      await clear();
      return null;
    }
  }

  @override
  Future<void> save(SavedCredentials credentials) async {
    await _storage.write(key: _cpfKey, value: credentials.cpf);
    await _storage.write(key: _passwordKey, value: credentials.password);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _cpfKey);
    await _storage.delete(key: _passwordKey);
  }
}
