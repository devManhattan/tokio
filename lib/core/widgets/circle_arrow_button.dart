import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CircleArrowButton extends StatelessWidget {
  const CircleArrowButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.brandGradient,
          border: Border.all(color: AppColors.surface, width: 6),
        ),
        child: const SizedBox(
          width: 72,
          height: 72,
          child: Icon(Icons.arrow_forward, color: Colors.white, size: 38),
        ),
      ),
    );
  }
}
