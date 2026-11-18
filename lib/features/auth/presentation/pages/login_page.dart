import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_checkbox.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/circle_arrow_button.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_tabs.dart';
import '../widgets/social_access.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final error = _validate();
    if (error != null) {
      showAppToast(context, error);
      return;
    }
    context.go(AppRoutes.home);
  }

  String? _validate() {
    final cpfDigits = _cpfController.text.replaceAll(RegExp(r'\D'), '');
    if (cpfDigits.length != 11) return 'Informe um CPF válido';
    if (_passwordController.text.isEmpty) return 'Informe a senha';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthLayout(
        title: 'Bem vindo!',
        subtitle: 'Aqui você gerencia seus seguros e de seus familiares em poucos cliques!',
        cardMinHeightFactor: 0.4,
        action: CircleArrowButton(onPressed: _submit),
        footer: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: SocialAccess(),
        ),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Stack(
      children: [
        Column(
          children: [
            AuthTabs(
              current: AuthTab.login,
              onEntrar: () {},
              onCadastrar: () => context.push(AppRoutes.register),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _cpfController,
              hint: 'CPF',
              filled: false,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _passwordController,
              hint: 'Senha',
              filled: false,
              textAlign: TextAlign.center,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AppCheckbox(
                        value: _rememberMe,
                        onChanged: (value) =>
                            setState(() => _rememberMe = value),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Flexible(
                        child: Text(
                          'Lembrar Sempre',
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.forgotPassword),
                    child: const Text(
                      'Esqueceu a senha?',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.end,
                      style: TextStyle(color: AppColors.primary, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
