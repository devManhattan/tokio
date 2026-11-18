import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokio_marine/core/di/injector.dart';
import 'package:tokio_marine/core/router/app_router.dart';
import 'package:tokio_marine/core/router/app_routes.dart';
import 'package:tokio_marine/core/theme/app_theme.dart';
import 'package:tokio_marine/features/auth/presentation/cubit/session_cubit.dart';

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
  await tester.pumpWidget(
    BlocProvider.value(
      value: sl<SessionCubit>(),
      child: MaterialApp(theme: AppTheme.dark, home: page),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpRouter(
  WidgetTester tester, {
  String initialLocation = AppRoutes.login,
  Size size = phoneSize,
}) async {
  setScreenSize(tester, size);
  final session = sl<SessionCubit>();
  final router = AppRouter(session: session, initialLocation: initialLocation);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    BlocProvider.value(
      value: session,
      child: MaterialApp.router(
        theme: AppTheme.dark,
        routerConfig: router.config,
      ),
    ),
  );
  await tester.pumpAndSettle();
}
