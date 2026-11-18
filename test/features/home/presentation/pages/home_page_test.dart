import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokio_marine/core/constants/app_constants.dart';
import 'package:tokio_marine/core/router/app_routes.dart';
import 'package:tokio_marine/features/auto/presentation/pages/auto_webview_page.dart';
import 'package:tokio_marine/features/home/presentation/pages/home_page.dart';
import 'package:tokio_marine/features/placeholder/presentation/pages/placeholder_page.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import '../../../../helpers/fake_webview_platform.dart';
import '../../../../helpers/test_app.dart';

const _products = ['Automóvel', 'Residência', 'Vida', 'Acidentes Pessoais'];

void main() {
  late FakeWebViewPlatform webViewPlatform;

  setUp(() {
    webViewPlatform = FakeWebViewPlatform();
    WebViewPlatform.instance = webViewPlatform;
  });

  Future<void> pumpHome(WidgetTester tester) {
    return pumpRouter(tester, initialLocation: AppRoutes.home);
  }

  testWidgets('shows the user name', (tester) async {
    await pumpHome(tester);

    expect(find.text(AppConstants.placeholderUserName), findsOneWidget);
  });

  testWidgets('shows the quote products', (tester) async {
    await pumpHome(tester);

    expect(find.text('Cotar e Contratar'), findsOneWidget);
    for (final product in _products) {
      expect(find.text(product), findsOneWidget);
    }
  });

  testWidgets('shows the family and contracted sections', (tester) async {
    await pumpHome(tester);

    expect(find.text('Minha Família'), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    expect(find.text('Contratados'), findsOneWidget);
    expect(
      find.text('Você ainda não possui seguros contratados.'),
      findsOneWidget,
    );
  });

  testWidgets('Automóvel opens the web view with the configured url', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.text('Automóvel'));
    await tester.pumpAndSettle();

    expect(find.byType(AutoWebViewPage), findsOneWidget);
    expect(webViewPlatform.loadedUrls, [Uri.parse(AppConstants.webViewUrl)]);
    expect(find.byType(LinearProgressIndicator), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('other products open their quote page', (tester) async {
    await pumpHome(tester);

    for (final product in _products.skip(1)) {
      await tester.tap(find.text(product));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Cotar $product'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('add family member opens the family page', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    expect(find.byType(PlaceholderPage), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Minha Família'), findsOneWidget);
  });
}
