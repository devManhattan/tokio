import '../../domain/usecases/send_password_reset.dart';
import 'submission_cubit.dart';

class ForgotPasswordCubit extends SubmissionCubit {
  ForgotPasswordCubit({required this._sendPasswordReset});

  final SendPasswordReset _sendPasswordReset;

  Future<void> submit({required String cpf}) {
    return run(() => _sendPasswordReset(cpf: cpf));
  }
}
