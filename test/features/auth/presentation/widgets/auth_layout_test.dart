import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokio_marine/core/widgets/circle_arrow_button.dart';
import 'package:tokio_marine/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:tokio_marine/features/auth/presentation/pages/login_page.dart';
import 'package:tokio_marine/features/auth/presentation/pages/register_page.dart';
import 'package:tokio_marine/features/auth/presentation/widgets/auth_card.dart';

import '../../../../helpers/test_app.dart';
import '../../../../helpers/test_environment.dart';

const _screens = {
  'tall phone': Size(412, 915),
  'regular phone': Size(412, 780),
  'short phone': Size(412, 600),
  'very short screen': Size(412, 450),
  'landscape phone': Size(915, 412),
};

const _pages = {
  'login': LoginPage(),
  'register': RegisterPage(),
  'forgot password': ForgotPasswordPage(),
};

void main() {
  for (final page in _pages.entries) {
    group('${page.key} layout', () {
      for (final screen in _screens.entries) {
        testWidgets('fits without overflow on ${screen.key}', (tester) async {
          await TestEnvironment.setUp();
          await pumpPage(tester, page.value, size: screen.value);

          expect(tester.takeException(), isNull);
          expect(find.byType(AuthCard), findsOneWidget);
        });
      }

      testWidgets('keeps its layout when the keyboard opens', (tester) async {
        await TestEnvironment.setUp();
        await pumpPage(tester, page.value, size: _screens['regular phone']!);
        final cardTop = tester.getTopLeft(find.byType(AuthCard));

        tester.view.viewInsets = const FakeViewPadding(bottom: 900);
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(tester.getTopLeft(find.byType(AuthCard)), cardTop);
      });
    });
  }

  group('submit button', () {
    final lastCardItems = {
      'login': (const LoginPage(), ['Lembrar Sempre', 'Esqueceu a senha?']),
      'register': (const RegisterPage(), ['Confirmar senha']),
      'forgot password': (const ForgotPasswordPage(), ['Voltar para o login']),
    };

    for (final entry in lastCardItems.entries) {
      final (page, labels) = entry.value;

      for (final screen in _screens.entries) {
        testWidgets(
          'does not cover the ${entry.key} card content on ${screen.key}',
          (tester) async {
            await TestEnvironment.setUp();
            await pumpPage(tester, page, size: screen.value);
            final button = tester.getRect(find.byType(CircleArrowButton));
            final card = tester.getRect(find.byType(AuthCard));

            for (final label in labels) {
              expect(
                button.top,
                greaterThan(tester.getRect(find.text(label)).bottom),
              );
            }
            expect(button.top, lessThan(card.bottom));
            expect(button.bottom, greaterThan(card.bottom));
          },
        );
      }
    }

    testWidgets('responds to taps across its whole area', (tester) async {
      await TestEnvironment.setUp();
      await pumpPage(tester, const LoginPage());
      final button = tester.getRect(find.byType(CircleArrowButton));
      final points = [
        button.center,
        button.topCenter + const Offset(0, 6),
        button.bottomCenter - const Offset(0, 6),
      ];

      for (final point in points) {
        await tester.tapAt(point);
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
        ScaffoldMessenger.of(tester.element(find.byType(LoginPage)))
            .removeCurrentSnackBar();
        await tester.pumpAndSettle();
      }
    });
  });
}
