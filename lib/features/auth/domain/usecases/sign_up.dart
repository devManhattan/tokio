import '../repositories/auth_repository.dart';

class SignUp {
  const SignUp(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call({
    required String name,
    required String cpf,
    required String email,
    required String password,
  }) {
    return _authRepository.signUp(
      name: name.trim(),
      cpf: cpf,
      email: email.trim().toLowerCase(),
      password: password,
    );
  }
}
