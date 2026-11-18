import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/failures/auth_failure.dart';
import 'submission_state.dart';

abstract class SubmissionCubit extends Cubit<SubmissionState> {
  SubmissionCubit() : super(const SubmissionState());

  @protected
  Future<void> run(Future<void> Function() action) async {
    if (state.isSubmitting) return;
    emit(const SubmissionState(status: SubmissionStatus.submitting));
    try {
      await action();
      _emitIfOpen(const SubmissionState(status: SubmissionStatus.success));
    } on AuthFailure catch (failure) {
      _emitIfOpen(
        SubmissionState(status: SubmissionStatus.failure, failure: failure),
      );
    } catch (_) {
      _emitIfOpen(
        const SubmissionState(
          status: SubmissionStatus.failure,
          failure: AuthFailure(AuthFailureType.unknown),
        ),
      );
    }
  }

  void _emitIfOpen(SubmissionState state) {
    if (!isClosed) emit(state);
  }
}
