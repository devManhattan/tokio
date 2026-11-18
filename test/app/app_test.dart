import 'package:flutter_test/flutter_test.dart';
import 'package:tokio_marine/app/app.dart';
import 'package:tokio_marine/features/auth/presentation/pages/login_page.dart';
import 'package:tokio_marine/features/home/presentation/pages/home_page.dart';

import '../helpers/test_app.dart';
import '../helpers/test_environment.dart';

void main() {
  testWidgets('starts on login when signed out', (tester) async {
    await TestEnvironment.setUp();
    setScreenSize(tester, phoneSize);

    await tester.pumpWidget(const TokioMarineApp());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('starts on home when the session is restored', (tester) async {
    await TestEnvironment.setUp(user: testUser);
    setScreenSize(tester, phoneSize);

    await tester.pumpWidget(const TokioMarineApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });
}
