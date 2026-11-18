import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/core/widgets/circle_arrow_button.dart';
import 'package:tokio_marine/features/auth/domain/failures/auth_failure.dart';
import 'package:tokio_marine/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:tokio_marine/features/auth/presentation/pages/login_page.dart';

import '../../../../helpers/test_app.dart';
import '../../../../helpers/test_environment.dart';

Future<void> _requestReset(WidgetTester tester, String cpf) async {
  await pumpRouter(tester);
  await tester.tap(find.text('Esqueceu a senha?'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), cpf);
  await tester.tap(find.byType(CircleArrowButton));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sends the reset email and returns to login', (tester) async {
    final environment = await TestEnvironment.setUp();
    when(
      () =>
          environment.authRepository.sendPasswordReset(cpf: any(named: 'cpf')),
    ).thenAnswer((_) async {});

    await _requestReset(tester, '12345678901');

    verify(
      () => environment.authRepository.sendPasswordReset(cpf: '12345678901'),
    ).called(1);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(
      find.text('Enviamos as instruções de recuperação para o seu e-mail.'),
      findsOneWidget,
    );
  });

  testWidgets('validates the CPF before calling the repository', (
    tester,
  ) async {
    final environment = await TestEnvironment.setUp();

    await _requestReset(tester, '123');

    expect(find.text('CPF deve ter 11 dígitos'), findsOneWidget);
    verifyNever(
      () =>
          environment.authRepository.sendPasswordReset(cpf: any(named: 'cpf')),
    );
  });

  testWidgets('stays on the page when the CPF is not registered', (
    tester,
  ) async {
    final environment = await TestEnvironment.setUp();
    when(
      () =>
          environment.authRepository.sendPasswordReset(cpf: any(named: 'cpf')),
    ).thenThrow(const AuthFailure(AuthFailureType.cpfNotFound));

    await _requestReset(tester, '12345678901');

    expect(find.text('CPF não encontrado'), findsOneWidget);
    expect(find.byType(ForgotPasswordPage), findsOneWidget);
  });
}
