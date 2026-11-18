import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_constants.dart';
import '../core/di/injector.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/cubit/session_cubit.dart';

class TokioMarineApp extends StatefulWidget {
  const TokioMarineApp({super.key});

  @override
  State<TokioMarineApp> createState() => _TokioMarineAppState();
}

class _TokioMarineAppState extends State<TokioMarineApp> {
  final SessionCubit _session = sl<SessionCubit>();
  late final AppRouter _router = AppRouter(session: _session);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _session,
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: _router.config,
      ),
    );
  }
}
