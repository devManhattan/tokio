import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/core/widgets/app_checkbox.dart';
import 'package:tokio_marine/core/widgets/circle_arrow_button.dart';
import 'package:tokio_marine/features/auth/domain/entities/saved_credentials.dart';
import 'package:tokio_marine/features/auth/domain/failures/auth_failure.dart';
import 'package:tokio_marine/features/home/presentation/pages/home_page.dart';

import '../../../../helpers/test_app.dart';
import '../../../../helpers/test_environment.dart';

Finder get _cpfField => find.byType(TextField).at(0);
Finder get _passwordField => find.byType(TextField).at(1);

Future<void> _fillAndSubmit(WidgetTester tester) async {
  await tester.enterText(_cpfField, '12345678901');
  await tester.enterText(_passwordField, 'secret123');
  await tester.tap(find.byType(CircleArrowButton));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('fills the form with remembered credentials', (tester) async {
    final environment = await TestEnvironment.setUp();
    when(() => environment.credentialsRepository.read()).thenAnswer(
      (_) async =>
          const SavedCredentials(cpf: '12345678901', password: 'secret123'),
    );

    await pumpRouter(tester);

    expect(tester.widget<TextField>(_cpfField).controller!.text, '12345678901');
    expect(
      tester.widget<TextField>(_passwordField).controller!.text,
      'secret123',
    );
    expect(tester.widget<AppCheckbox>(find.byType(AppCheckbox)).value, isTrue);
  });

  testWidgets('validates the form before calling the repository', (
    tester,
  ) async {
    final environment = await TestEnvironment.setUp();
    await pumpRouter(tester);

    await tester.tap(find.byType(CircleArrowButton));
    await tester.pump();

    expect(find.text('Informe um CPF válido'), findsOneWidget);
    verifyNever(
      () => environment.authRepository.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('signs in, forgets credentials and opens home', (tester) async {
    final environment = await TestEnvironment.setUp();
    when(
      () => environment.authRepository.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => environment.emitUser(testUser));
    await pumpRouter(tester);

    await _fillAndSubmit(tester);

    verify(
      () => environment.authRepository.signIn(
        cpf: '12345678901',
        password: 'secret123',
      ),
    ).called(1);
    verify(() => environment.credentialsRepository.clear()).called(1);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('remembers credentials when Lembrar Sempre is checked', (
    tester,
  ) async {
    final environment = await TestEnvironment.setUp();
    when(
      () => environment.authRepository.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    await pumpRouter(tester);

    await tester.tap(find.byType(AppCheckbox));
    await _fillAndSubmit(tester);

    verify(
      () => environment.credentialsRepository.save(
        const SavedCredentials(cpf: '12345678901', password: 'secret123'),
      ),
    ).called(1);
  });

  testWidgets('shows the failure message when sign in fails', (tester) async {
    final environment = await TestEnvironment.setUp();
    when(
      () => environment.authRepository.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const AuthFailure(AuthFailureType.invalidCredentials));
    await pumpRouter(tester);

    await _fillAndSubmit(tester);

    expect(find.text('CPF ou senha inválidos'), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });
}
