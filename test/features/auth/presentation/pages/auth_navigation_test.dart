import 'package:flutter_test/flutter_test.dart';
import 'package:tokio_marine/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:tokio_marine/features/auth/presentation/pages/login_page.dart';
import 'package:tokio_marine/features/auth/presentation/pages/register_page.dart';

import '../../../../helpers/test_app.dart';

void main() {
  testWidgets('login is the initial screen', (tester) async {
    await pumpRouter(tester);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Bem vindo!'), findsOneWidget);
  });

  testWidgets('Cadastrar tab opens the register page and Entrar returns', (
    tester,
  ) async {
    await pumpRouter(tester);

    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('Esqueceu a senha? opens the recovery page and back returns', (
    tester,
  ) async {
    await pumpRouter(tester);

    await tester.tap(find.text('Esqueceu a senha?'));
    await tester.pumpAndSettle();
    expect(find.byType(ForgotPasswordPage), findsOneWidget);

    await tester.tap(find.text('Voltar para o login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
