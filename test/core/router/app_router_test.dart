import 'package:flutter_test/flutter_test.dart';
import 'package:tokio_marine/core/router/app_routes.dart';
import 'package:tokio_marine/features/auth/presentation/pages/login_page.dart';
import 'package:tokio_marine/features/home/presentation/pages/home_page.dart';

import '../../helpers/test_app.dart';
import '../../helpers/test_environment.dart';

void main() {
  testWidgets('signed out users are sent to login from private routes', (
    tester,
  ) async {
    await TestEnvironment.setUp();
    await pumpRouter(tester, initialLocation: AppRoutes.home);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('signed in users skip the login', (tester) async {
    await TestEnvironment.setUp(user: testUser);
    await pumpRouter(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('session changes move the user between login and home', (
    tester,
  ) async {
    final environment = await TestEnvironment.setUp();
    await pumpRouter(tester);

    environment.emitUser(testUser);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);

    environment.emitUser(null);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
