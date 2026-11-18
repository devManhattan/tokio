import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_toast.dart';
import '../cubit/submission_cubit.dart';
import '../cubit/submission_state.dart';
import '../utils/auth_failure_message.dart';

class SubmissionListener<C extends SubmissionCubit> extends StatelessWidget {
  const SubmissionListener({super.key, required this.child, this.onSuccess});

  final Widget child;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, SubmissionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case SubmissionStatus.failure:
            showAppToast(context, state.failure!.message);
          case SubmissionStatus.success:
            onSuccess?.call();
          case SubmissionStatus.idle || SubmissionStatus.submitting:
            break;
        }
      },
      child: child,
    );
  }
}
