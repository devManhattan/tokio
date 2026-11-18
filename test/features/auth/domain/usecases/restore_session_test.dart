import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/features/auth/domain/entities/saved_credentials.dart';
import 'package:tokio_marine/features/auth/domain/usecases/restore_session.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockCredentialsRepository credentialsRepository;
  late RestoreSession restoreSession;

  setUp(() {
    authRepository = MockAuthRepository();
    credentialsRepository = MockCredentialsRepository();
    restoreSession = RestoreSession(authRepository, credentialsRepository);
    when(() => authRepository.signOut()).thenAnswer((_) async {});
  });

  test('signs out when nothing was remembered', () async {
    when(() => credentialsRepository.read()).thenAnswer((_) async => null);

    await restoreSession();

    verify(() => authRepository.signOut()).called(1);
  });

  test('keeps the session when credentials were remembered', () async {
    when(() => credentialsRepository.read()).thenAnswer(
      (_) async => const SavedCredentials(cpf: '12345678901', password: 'x'),
    );

    await restoreSession();

    verifyNever(() => authRepository.signOut());
  });
}
