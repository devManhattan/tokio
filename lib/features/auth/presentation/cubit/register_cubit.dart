import '../../domain/usecases/sign_up.dart';
import 'submission_cubit.dart';

class RegisterCubit extends SubmissionCubit {
  RegisterCubit({required this._signUp});

  final SignUp _signUp;

  Future<void> submit({
    required String name,
    required String cpf,
    required String email,
    required String password,
  }) {
    return run(
      () => _signUp(name: name, cpf: cpf, email: email, password: password),
    );
  }
}
