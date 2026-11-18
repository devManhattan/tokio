import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_tabs.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _backToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthLayout(
        title: 'Criar conta',
        subtitle: 'Cadastre-se para acompanhar seus seguros em um só lugar.',
        cardMinHeightFactor: 0.62,
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        AuthTabs(
          current: AuthTab.register,
          onEntrar: _backToLogin,
          onCadastrar: () {},
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          controller: _nameController,
          hint: 'Nome completo',
          filled: false,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: _cpfController,
          hint: 'CPF',
          filled: false,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: _emailController,
          hint: 'E-mail',
          filled: false,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: _passwordController,
          hint: 'Senha',
          filled: false,
          textAlign: TextAlign.center,
          obscureText: true,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: _confirmController,
          hint: 'Confirmar senha',
          filled: false,
          textAlign: TextAlign.center,
          obscureText: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
