import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/features/auth/domain/entities/app_user.dart';
import 'package:tokio_marine/features/auth/domain/usecases/sign_out.dart';
import 'package:tokio_marine/features/auth/domain/usecases/watch_current_user.dart';
import 'package:tokio_marine/features/auth/presentation/cubit/session_cubit.dart';
import 'package:tokio_marine/features/auth/presentation/cubit/session_state.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_environment.dart';

void main() {
  late MockAuthRepository authRepository;
  late StreamController<AppUser?> users;
  late SessionCubit cubit;

  setUp(() {
    authRepository = MockAuthRepository();
    users = StreamController<AppUser?>();
    when(() => authRepository.watchUser()).thenAnswer((_) => users.stream);
    when(() => authRepository.signOut()).thenAnswer((_) async {});
    cubit = SessionCubit(
      watchCurrentUser: WatchCurrentUser(authRepository),
      signOut: SignOut(authRepository),
    );
  });

  tearDown(() async {
    await cubit.close();
    unawaited(users.close());
  });

  test('starts unknown', () {
    expect(cubit.state, const SessionState.unknown());
  });

  test('start completes once the first session event arrives', () async {
    var started = false;
    final start = cubit.start().then((_) => started = true);

    await Future<void>.delayed(Duration.zero);
    expect(started, isFalse);

    users.add(testUser);
    await start;
    expect(cubit.state, const SessionState.authenticated(testUser));
  });

  test('follows sign in and sign out events', () async {
    users.add(null);
    await cubit.start();
    expect(cubit.state, const SessionState.unauthenticated());

    users.add(testUser);
    await expectLater(
      cubit.stream,
      emits(const SessionState.authenticated(testUser)),
    );

    users.add(null);
    await expectLater(
      cubit.stream,
      emits(const SessionState.unauthenticated()),
    );
  });

  test('signOut delegates to the repository', () async {
    await cubit.signOut();

    verify(() => authRepository.signOut()).called(1);
  });
}
