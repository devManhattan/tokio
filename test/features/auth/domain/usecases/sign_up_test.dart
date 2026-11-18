import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/features/auth/domain/usecases/sign_up.dart';

import '../../../../helpers/mocks.dart';

void main() {
  test('normalizes name and email before creating the account', () async {
    final authRepository = MockAuthRepository();
    when(
      () => authRepository.signUp(
        name: any(named: 'name'),
        cpf: any(named: 'cpf'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    await SignUp(authRepository)(
      name: ' Maria Souza ',
      cpf: '12345678901',
      email: ' Maria@Email.COM ',
      password: 'secret123',
    );

    verify(
      () => authRepository.signUp(
        name: 'Maria Souza',
        cpf: '12345678901',
        email: 'maria@email.com',
        password: 'secret123',
      ),
    ).called(1);
  });
}
