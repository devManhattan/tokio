import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> watchUser();

  Future<void> signIn({required String cpf, required String password});

  Future<void> signUp({
    required String name,
    required String cpf,
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset({required String cpf});

  Future<void> signOut();
}
