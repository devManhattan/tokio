import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CircleArrowButton extends StatelessWidget {
  const CircleArrowButton({
    super.key,
    required this.onPressed,
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.brandGradient,
          border: Border.all(color: AppColors.surface, width: 6),
        ),
        child: SizedBox(
          width: 72,
          height: 72,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 38,
                  ),
          ),
        ),
      ),
    );
  }
}
