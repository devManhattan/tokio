import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Stream<AppUser?> watchUser() => _remote.watchUser();

  @override
  Future<void> signIn({required String cpf, required String password}) {
    return _guard(() async {
      final email = await _remote.findEmailByCpf(cpf);
      if (email == null) {
        throw const AuthFailure(AuthFailureType.invalidCredentials);
      }
      await _remote.signIn(email: email, password: password);
    });
  }

  @override
  Future<void> signUp({
    required String name,
    required String cpf,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      if (await _remote.findEmailByCpf(cpf) != null) {
        throw const AuthFailure(AuthFailureType.cpfAlreadyInUse);
      }
      await _remote.createAccount(
        name: name,
        cpf: cpf,
        email: email,
        password: password,
      );
    });
  }

  @override
  Future<void> sendPasswordReset({required String cpf}) {
    return _guard(() async {
      final email = await _remote.findEmailByCpf(cpf);
      if (email == null) {
        throw const AuthFailure(AuthFailureType.cpfNotFound);
      }
      await _remote.sendPasswordResetEmail(email);
    });
  }

  @override
  Future<void> signOut() => _guard(_remote.signOut);

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_authFailureType(error.code));
    } on FirebaseException catch (error) {
      throw AuthFailure(
        error.code == 'unavailable'
            ? AuthFailureType.network
            : AuthFailureType.unknown,
      );
    } catch (_) {
      throw const AuthFailure(AuthFailureType.unknown);
    }
  }

  AuthFailureType _authFailureType(String code) {
    return switch (code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'user-disabled' => AuthFailureType.invalidCredentials,
      'email-already-in-use' => AuthFailureType.emailAlreadyInUse,
      'invalid-email' => AuthFailureType.invalidEmail,
      'weak-password' => AuthFailureType.weakPassword,
      'network-request-failed' => AuthFailureType.network,
      'too-many-requests' => AuthFailureType.tooManyRequests,
      _ => AuthFailureType.unknown,
    };
  }
}
