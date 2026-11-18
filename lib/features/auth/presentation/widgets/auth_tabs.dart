import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum AuthTab { login, register }

class AuthTabs extends StatelessWidget {
  const AuthTabs({
    super.key,
    required this.current,
    required this.onEntrar,
    required this.onCadastrar,
  });

  final AuthTab current;
  final VoidCallback onEntrar;
  final VoidCallback onCadastrar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Tab(
          label: 'Entrar',
          active: current == AuthTab.login,
          onTap: onEntrar,
        ),
        const SizedBox(width: 28),
        _Tab(
          label: 'Cadastrar',
          active: current == AuthTab.register,
          onTap: onCadastrar,
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            if (active)
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
