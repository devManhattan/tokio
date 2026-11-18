import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/core/widgets/circle_arrow_button.dart';
import 'package:tokio_marine/features/auth/domain/failures/auth_failure.dart';
import 'package:tokio_marine/features/auth/presentation/pages/register_page.dart';
import 'package:tokio_marine/features/home/presentation/pages/home_page.dart';

import '../../../../helpers/test_app.dart';
import '../../../../helpers/test_environment.dart';

Future<void> _openRegister(WidgetTester tester) async {
  await pumpRouter(tester);
  await tester.tap(find.text('Cadastrar'));
  await tester.pumpAndSettle();
}

Future<void> _fill(
  WidgetTester tester, {
  String confirmation = 'secret123',
}) async {
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), 'Maria Souza');
  await tester.enterText(fields.at(1), '12345678901');
  await tester.enterText(fields.at(2), 'Maria@Email.com');
  await tester.enterText(fields.at(3), 'secret123');
  await tester.enterText(fields.at(4), confirmation);
}

Future<void> _submit(WidgetTester tester) async {
  await tester.ensureVisible(find.byType(CircleArrowButton));
  await tester.tap(find.byType(CircleArrowButton));
  await tester.pumpAndSettle();
}

void _stubSignUp(TestEnvironment environment, Future<void> Function() answer) {
  when(
    () => environment.authRepository.signUp(
      name: any(named: 'name'),
      cpf: any(named: 'cpf'),
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) => answer());
}

void main() {
  testWidgets('creates the account and opens home', (tester) async {
    final environment = await TestEnvironment.setUp();
    _stubSignUp(environment, () async => environment.emitUser(testUser));
    await _openRegister(tester);

    await _fill(tester);
    await _submit(tester);

    verify(
      () => environment.authRepository.signUp(
        name: 'Maria Souza',
        cpf: '12345678901',
        email: 'maria@email.com',
        password: 'secret123',
      ),
    ).called(1);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('rejects a password confirmation that does not match', (
    tester,
  ) async {
    final environment = await TestEnvironment.setUp();
    await _openRegister(tester);

    await _fill(tester, confirmation: 'other');
    await _submit(tester);

    expect(find.text('As senhas não conferem'), findsOneWidget);
    verifyNever(
      () => environment.authRepository.signUp(
        name: any(named: 'name'),
        cpf: any(named: 'cpf'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('shows the failure message when the CPF is taken', (
    tester,
  ) async {
    final environment = await TestEnvironment.setUp();
    _stubSignUp(
      environment,
      () async => throw const AuthFailure(AuthFailureType.cpfAlreadyInUse),
    );
    await _openRegister(tester);

    await _fill(tester);
    await _submit(tester);

    expect(find.text('Já existe uma conta com este CPF'), findsOneWidget);
    expect(find.byType(RegisterPage), findsOneWidget);
  });
}
