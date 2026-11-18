import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/di/injector.dart';
import 'features/auth/domain/usecases/restore_session.dart';
import 'features/auth/presentation/cubit/session_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  await sl<RestoreSession>()();
  await sl<SessionCubit>().start();
  runApp(const TokioMarineApp());
}
