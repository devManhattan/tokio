import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tokio_marine/features/auth/domain/failures/auth_failure.dart';

import '../../../../helpers/mocks.dart';

const _cpf = '12345678901';
const _email = 'maria@email.com';

Matcher _throwsFailure(AuthFailureType type) {
  return throwsA(isA<AuthFailure>().having((f) => f.type, 'type', type));
}

void main() {
  late MockAuthRemoteDataSource remote;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remote);
  });

  group('signIn', () {
    test('signs in with the email registered for the CPF', () async {
      when(() => remote.findEmailByCpf(_cpf)).thenAnswer((_) async => _email);
      when(() => remote.signIn(email: _email, password: 'secret'))
          .thenAnswer((_) async {});

      await repository.signIn(cpf: _cpf, password: 'secret');

      verify(() => remote.signIn(email: _email, password: 'secret')).called(1);
    });

    test('reports invalid credentials for an unknown CPF', () {
      when(() => remote.findEmailByCpf(_cpf)).thenAnswer((_) async => null);

      expect(
        repository.signIn(cpf: _cpf, password: 'secret'),
        _throwsFailure(AuthFailureType.invalidCredentials),
      );
    });

    final codes = {
      'invalid-credential': AuthFailureType.invalidCredentials,
      'wrong-password': AuthFailureType.invalidCredentials,
      'network-request-failed': AuthFailureType.network,
      'too-many-requests': AuthFailureType.tooManyRequests,
      'internal-error': AuthFailureType.unknown,
    };

    for (final entry in codes.entries) {
      test('maps ${entry.key} to ${entry.value.name}', () {
        when(() => remote.findEmailByCpf(_cpf)).thenAnswer((_) async => _email);
        when(
          () => remote.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: entry.key));

        expect(
          repository.signIn(cpf: _cpf, password: 'secret'),
          _throwsFailure(entry.value),
        );
      });
    }

    test('maps an unavailable Firestore to a network failure', () {
      when(() => remote.findEmailByCpf(_cpf)).thenThrow(
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
      );

      expect(
        repository.signIn(cpf: _cpf, password: 'secret'),
        _throwsFailure(AuthFailureType.network),
      );
    });
  });

  group('signUp', () {
    Future<void> signUp() {
      return repository.signUp(
        name: 'Maria Souza',
        cpf: _cpf,
        email: _email,
        password: 'secret123',
      );
    }

    test('creates the account when the CPF is free', () async {
      when(() => remote.findEmailByCpf(_cpf)).thenAnswer((_) async => null);
      when(
        () => remote.createAccount(
          name: any(named: 'name'),
          cpf: any(named: 'cpf'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});

      await signUp();

      verify(
        () => remote.createAccount(
          name: 'Maria Souza',
          cpf: _cpf,
          email: _email,
          password: 'secret123',
        ),
      ).called(1);
    });

    test('rejects a CPF that is already registered', () {
      when(() => remote.findEmailByCpf(_cpf)).thenAnswer((_) async => _email);

      expect(signUp(), _throwsFailure(AuthFailureType.cpfAlreadyInUse));
    });

    test('maps email-already-in-use and weak-password', () async {
      when(() => remote.findEmailByCpf(_cpf)).thenAnswer((_) async => null);

      for (final entry in {
        'email-already-in-use': AuthFailureType.emailAlreadyInUse,
        'weak-password': AuthFailureType.weakPassword,
      }.entries) {
        when(
          () => remote.createAccount(
            name: any(named: 'name'),
            cpf: any(named: 'cpf'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: entry.key));

        await expectLater(signUp(), _throwsFailure(entry.value));
      }
    });
  });

  group('sendPasswordReset', () {
    test('sends the email registered for the CPF', () async {
      when(() => remote.findEmailByCpf(_cpf)).thenAnswer((_) async => _email);
      when(() => remote.sendPasswordResetEmail(_email))
          .thenAnswer((_) async {});

      await repository.sendPasswordReset(cpf: _cpf);

      verify(() => remote.sendPasswordResetEmail(_email)).called(1);
    });

    test('reports an unknown CPF', () {
      when(() => remote.findEmailByCpf(_cpf)).thenAnswer((_) async => null);

      expect(
        repository.sendPasswordReset(cpf: _cpf),
        _throwsFailure(AuthFailureType.cpfNotFound),
      );
    });
  });
}
