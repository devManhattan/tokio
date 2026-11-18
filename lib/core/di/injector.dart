import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/secure_credentials_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/credentials_repository.dart';
import '../../features/auth/domain/usecases/get_saved_credentials.dart';
import '../../features/auth/domain/usecases/restore_session.dart';
import '../../features/auth/domain/usecases/send_password_reset.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/domain/usecases/watch_current_user.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/auth/presentation/cubit/session_cubit.dart';

final GetIt sl = GetIt.instance;

void configureDependencies() {
  sl
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => const FlutterSecureStorage())
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => FirebaseAuthRemoteDataSource(sl(), sl()),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton<CredentialsRepository>(
      () => SecureCredentialsRepository(sl()),
    );
  registerAuthFeature();
}

void registerAuthFeature() {
  sl
    ..registerFactory(() => SignIn(sl(), sl()))
    ..registerFactory(() => SignUp(sl()))
    ..registerFactory(() => SendPasswordReset(sl()))
    ..registerFactory(() => SignOut(sl()))
    ..registerFactory(() => WatchCurrentUser(sl()))
    ..registerFactory(() => GetSavedCredentials(sl()))
    ..registerFactory(() => RestoreSession(sl(), sl()))
    ..registerLazySingleton(
      () => SessionCubit(watchCurrentUser: sl(), signOut: sl()),
      dispose: (cubit) => cubit.close(),
    )
    ..registerFactory(() => LoginCubit(signIn: sl(), getSavedCredentials: sl()))
    ..registerFactory(() => RegisterCubit(signUp: sl()))
    ..registerFactory(() => ForgotPasswordCubit(sendPasswordReset: sl()));
}
