import '../../domain/entities/saved_credentials.dart';
import '../../domain/usecases/get_saved_credentials.dart';
import '../../domain/usecases/sign_in.dart';
import 'submission_cubit.dart';

class LoginCubit extends SubmissionCubit {
  LoginCubit({required this._signIn, required this._getSavedCredentials});

  final SignIn _signIn;
  final GetSavedCredentials _getSavedCredentials;

  Future<SavedCredentials?> savedCredentials() => _getSavedCredentials();

  Future<void> submit({
    required String cpf,
    required String password,
    required bool remember,
  }) {
    return run(() => _signIn(cpf: cpf, password: password, remember: remember));
  }
}
