import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

void showAppToast(BuildContext context, String message, {bool isError = true}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.danger : AppColors.primary,
      ),
    );
}
