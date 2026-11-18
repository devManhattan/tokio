import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/core/router/app_routes.dart';
import 'package:tokio_marine/features/auth/presentation/pages/login_page.dart';
import 'package:tokio_marine/features/home/presentation/pages/home_page.dart';

import '../../../../helpers/test_app.dart';
import '../../../../helpers/test_environment.dart';

const _menuItems = [
  'Home / Seguros',
  'Minhas Contratações',
  'Meus Sinistros',
  'Minha Família',
  'Meus Bens',
  'Pagamentos',
  'Coberturas',
  'Validar Boleto',
  'Telefones Importantes',
  'Configurações',
];

Finder _inDrawer(String text) {
  return find.descendant(of: find.byType(Drawer), matching: find.text(text));
}

Future<void> _openDrawer(WidgetTester tester) async {
  tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
  await tester.pumpAndSettle();
}

void main() {
  Future<TestEnvironment> pumpHome(WidgetTester tester) async {
    final environment = await TestEnvironment.setUp(user: testUser);
    await pumpRouter(tester, initialLocation: AppRoutes.home);
    return environment;
  }

  testWidgets('shows the user name and avatar', (tester) async {
    await pumpHome(tester);
    await _openDrawer(tester);

    expect(_inDrawer(testUser.name.toUpperCase()), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.byType(CircleAvatar),
      ),
      findsWidgets,
    );
  });

  testWidgets('lists the menu items in order', (tester) async {
    await pumpHome(tester);
    await _openDrawer(tester);

    final positions = [
      for (final item in _menuItems) tester.getTopLeft(_inDrawer(item)).dy,
    ];

    expect(positions, orderedEquals([...positions]..sort()));
  });

  testWidgets('Home / Seguros keeps the user on home', (tester) async {
    await pumpHome(tester);
    await _openDrawer(tester);

    await tester.tap(_inDrawer('Home / Seguros'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
  });

  testWidgets('each menu item opens its page and back returns home', (
    tester,
  ) async {
    await pumpHome(tester);

    for (final item in _menuItems.skip(1)) {
      await _openDrawer(tester);
      await tester.ensureVisible(_inDrawer(item));
      await tester.tap(_inDrawer(item));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, item), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    }
  });

  testWidgets('Sair signs out and returns to login', (tester) async {
    final environment = await pumpHome(tester);
    await _openDrawer(tester);

    await tester.ensureVisible(_inDrawer('Sair'));
    await tester.tap(_inDrawer('Sair'));
    await tester.pumpAndSettle();

    verify(() => environment.authRepository.signOut()).called(1);
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
