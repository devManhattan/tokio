import 'package:equatable/equatable.dart';

import '../../domain/failures/auth_failure.dart';

enum SubmissionStatus { idle, submitting, success, failure }

class SubmissionState extends Equatable {
  const SubmissionState({this.status = SubmissionStatus.idle, this.failure});

  final SubmissionStatus status;
  final AuthFailure? failure;

  bool get isSubmitting => status == SubmissionStatus.submitting;

  @override
  List<Object?> get props => [status, failure];
}
