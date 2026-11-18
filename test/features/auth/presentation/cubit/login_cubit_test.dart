import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/features/auth/domain/entities/saved_credentials.dart';
import 'package:tokio_marine/features/auth/domain/failures/auth_failure.dart';
import 'package:tokio_marine/features/auth/domain/usecases/get_saved_credentials.dart';
import 'package:tokio_marine/features/auth/domain/usecases/sign_in.dart';
import 'package:tokio_marine/features/auth/presentation/cubit/login_cubit.dart';
import 'package:tokio_marine/features/auth/presentation/cubit/submission_state.dart';

import '../../../../helpers/mocks.dart';

const _submitting = SubmissionState(status: SubmissionStatus.submitting);

void main() {
  late MockAuthRepository authRepository;
  late MockCredentialsRepository credentialsRepository;

  setUpAll(() {
    registerFallbackValue(const SavedCredentials(cpf: '', password: ''));
  });

  setUp(() {
    authRepository = MockAuthRepository();
    credentialsRepository = MockCredentialsRepository();
    when(() => credentialsRepository.clear()).thenAnswer((_) async {});
    when(() => credentialsRepository.save(any())).thenAnswer((_) async {});
  });

  LoginCubit buildCubit() {
    return LoginCubit(
      signIn: SignIn(authRepository, credentialsRepository),
      getSavedCredentials: GetSavedCredentials(credentialsRepository),
    );
  }

  void stubSignIn(Future<void> Function() answer) {
    when(
      () => authRepository.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) => answer());
  }

  Future<void> submit(LoginCubit cubit) {
    return cubit.submit(
      cpf: '12345678901',
      password: 'secret',
      remember: false,
    );
  }

  blocTest<LoginCubit, SubmissionState>(
    'emits submitting then success when sign in works',
    setUp: () => stubSignIn(() async {}),
    build: buildCubit,
    act: submit,
    expect: () => const [
      _submitting,
      SubmissionState(status: SubmissionStatus.success),
    ],
  );

  blocTest<LoginCubit, SubmissionState>(
    'emits the auth failure when sign in fails',
    setUp: () => stubSignIn(
      () async => throw const AuthFailure(AuthFailureType.invalidCredentials),
    ),
    build: buildCubit,
    act: submit,
    expect: () => const [
      _submitting,
      SubmissionState(
        status: SubmissionStatus.failure,
        failure: AuthFailure(AuthFailureType.invalidCredentials),
      ),
    ],
  );

  blocTest<LoginCubit, SubmissionState>(
    'turns unexpected errors into an unknown failure',
    setUp: () => stubSignIn(() async => throw StateError('boom')),
    build: buildCubit,
    act: submit,
    expect: () => const [
      _submitting,
      SubmissionState(
        status: SubmissionStatus.failure,
        failure: AuthFailure(AuthFailureType.unknown),
      ),
    ],
  );

  blocTest<LoginCubit, SubmissionState>(
    'ignores a second submit while the first is running',
    setUp: () => stubSignIn(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    ),
    build: buildCubit,
    act: (cubit) => Future.wait([submit(cubit), submit(cubit)]),
    expect: () => const [
      _submitting,
      SubmissionState(status: SubmissionStatus.success),
    ],
    verify: (_) => verify(
      () => authRepository.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
      ),
    ).called(1),
  );

  test('exposes the remembered credentials', () async {
    const credentials = SavedCredentials(cpf: '12345678901', password: 'x');
    when(() => credentialsRepository.read())
        .thenAnswer((_) async => credentials);

    final cubit = buildCubit();
    addTearDown(cubit.close);

    expect(await cubit.savedCredentials(), credentials);
  });
}
