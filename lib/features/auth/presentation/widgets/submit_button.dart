import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/circle_arrow_button.dart';
import '../cubit/submission_cubit.dart';
import '../cubit/submission_state.dart';

class SubmitButton<C extends SubmissionCubit> extends StatelessWidget {
  const SubmitButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<C, SubmissionState, bool>(
      selector: (state) => state.isSubmitting,
      builder: (context, submitting) =>
          CircleArrowButton(onPressed: onPressed, loading: submitting),
    );
  }
}
