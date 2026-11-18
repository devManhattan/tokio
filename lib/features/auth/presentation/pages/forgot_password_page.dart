import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/circle_arrow_button.dart';
import '../widgets/auth_layout.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _cpfController = TextEditingController();

  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

  void _submit() {
    final error = Validators.cpf(_cpfController.text);
    if (error != null) {
      showAppToast(context, error);
      return;
    }
    showAppToast(
      context,
      'Enviamos as instruções de recuperação para o seu e-mail.',
      isError: false,
    );
    _back();
  }

  void _back() {
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
        title: 'Recuperar senha',
        subtitle: 'Informe o CPF cadastrado para receber as instruções de recuperação.',
        cardMinHeightFactor: 0.25,
        action: CircleArrowButton(onPressed: _submit),
        child: Column(
          children: [
            AppTextField(
              controller: _cpfController,
              hint: 'CPF',
              filled: false,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: AppSpacing.lg),
            InkWell(
              onTap: _back,
              child: const Text(
                'Voltar para o login',
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
