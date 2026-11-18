import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/core/di/injector.dart';
import 'package:tokio_marine/features/auth/domain/entities/app_user.dart';
import 'package:tokio_marine/features/auth/domain/entities/saved_credentials.dart';
import 'package:tokio_marine/features/auth/domain/repositories/auth_repository.dart';
import 'package:tokio_marine/features/auth/domain/repositories/credentials_repository.dart';
import 'package:tokio_marine/features/auth/presentation/cubit/session_cubit.dart';

import 'mocks.dart';

const testUser = AppUser(
  id: 'user-1',
  name: 'Maria Souza',
  email: 'maria@email.com',
);

class TestEnvironment {
  TestEnvironment._();

  final authRepository = MockAuthRepository();
  final credentialsRepository = MockCredentialsRepository();
  final _users = StreamController<AppUser?>();

  static Future<TestEnvironment> setUp({AppUser? user}) async {
    registerFallbackValue(const SavedCredentials(cpf: '', password: ''));
    final environment = TestEnvironment._().._stubDefaults();

    await sl.reset();
    sl
      ..registerSingleton<AuthRepository>(environment.authRepository)
      ..registerSingleton<CredentialsRepository>(
        environment.credentialsRepository,
      );
    registerAuthFeature();

    environment.emitUser(user);
    await sl<SessionCubit>().start();

    addTearDown(() async {
      await sl.reset();
      await environment._users.close();
    });
    return environment;
  }

  void emitUser(AppUser? user) => _users.add(user);

  void _stubDefaults() {
    when(() => authRepository.watchUser()).thenAnswer((_) => _users.stream);
    when(() => authRepository.signOut()).thenAnswer((_) async {
      emitUser(null);
    });
    when(() => credentialsRepository.read()).thenAnswer((_) async => null);
    when(() => credentialsRepository.save(any())).thenAnswer((_) async {});
    when(() => credentialsRepository.clear()).thenAnswer((_) async {});
  }
}
