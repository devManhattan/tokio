import '../../domain/entities/app_user.dart';

abstract class AuthRemoteDataSource {
  Stream<AppUser?> watchUser();

  Future<String?> findEmailByCpf(String cpf);

  Future<void> signIn({required String email, required String password});

  Future<void> createAccount({
    required String name,
    required String cpf,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}
