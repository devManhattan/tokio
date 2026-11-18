import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokio_marine/core/router/app_router.dart';
import 'package:tokio_marine/core/router/app_routes.dart';
import 'package:tokio_marine/core/theme/app_theme.dart';

const Size phoneSize = Size(412, 915);

void setScreenSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Future<void> pumpPage(
  WidgetTester tester,
  Widget page, {
  Size size = phoneSize,
}) async {
  setScreenSize(tester, size);
  await tester.pumpWidget(MaterialApp(theme: AppTheme.dark, home: page));
  await tester.pumpAndSettle();
}

Future<void> pumpRouter(
  WidgetTester tester, {
  String initialLocation = AppRoutes.login,
  Size size = phoneSize,
}) async {
  setScreenSize(tester, size);
  final router = createAppRouter(initialLocation: initialLocation);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
  );
  await tester.pumpAndSettle();
}
