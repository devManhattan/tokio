import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/features/auth/domain/entities/saved_credentials.dart';
import 'package:tokio_marine/features/auth/domain/failures/auth_failure.dart';
import 'package:tokio_marine/features/auth/domain/usecases/sign_in.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockCredentialsRepository credentialsRepository;
  late SignIn signIn;

  setUpAll(() {
    registerFallbackValue(const SavedCredentials(cpf: '', password: ''));
  });

  setUp(() {
    authRepository = MockAuthRepository();
    credentialsRepository = MockCredentialsRepository();
    signIn = SignIn(authRepository, credentialsRepository);
    when(
      () => authRepository.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    when(() => credentialsRepository.save(any())).thenAnswer((_) async {});
    when(() => credentialsRepository.clear()).thenAnswer((_) async {});
  });

  test('saves the credentials when remember is on', () async {
    await signIn(cpf: '12345678901', password: 'secret', remember: true);

    verify(
      () => credentialsRepository.save(
        const SavedCredentials(cpf: '12345678901', password: 'secret'),
      ),
    ).called(1);
    verifyNever(() => credentialsRepository.clear());
  });

  test('clears the credentials when remember is off', () async {
    await signIn(cpf: '12345678901', password: 'secret', remember: false);

    verify(() => credentialsRepository.clear()).called(1);
    verifyNever(() => credentialsRepository.save(any()));
  });

  test('keeps the stored credentials when sign in fails', () async {
    when(
      () => authRepository.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const AuthFailure(AuthFailureType.invalidCredentials));

    await expectLater(
      signIn(cpf: '12345678901', password: 'wrong', remember: true),
      throwsA(isA<AuthFailure>()),
    );

    verifyNever(() => credentialsRepository.save(any()));
    verifyNever(() => credentialsRepository.clear());
  });
}
