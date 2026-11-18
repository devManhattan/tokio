import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../cubit/register_cubit.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_tabs.dart';
import '../widgets/submission_listener.dart';
import '../widgets/submit_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
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

  void _submit() {
    final error = _validate();
    if (error != null) {
      showAppToast(context, error);
      return;
    }
    context.read<RegisterCubit>().submit(
      name: _nameController.text,
      cpf: _cpfController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  String? _validate() {
    return Validators.required(_nameController.text, field: 'Nome') ??
        Validators.cpf(_cpfController.text) ??
        Validators.email(_emailController.text) ??
        Validators.password(_passwordController.text) ??
        (_confirmController.text != _passwordController.text
            ? 'As senhas não conferem'
            : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SubmissionListener<RegisterCubit>(
        child: AuthLayout(
          title: 'Criar conta',
          subtitle: 'Cadastre-se para acompanhar seus seguros em um só lugar.',
          cardMinHeightFactor: 0.62,
          action: SubmitButton<RegisterCubit>(onPressed: _submit),
          child: _buildForm(),
        ),
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
