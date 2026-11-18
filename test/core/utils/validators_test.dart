import 'package:flutter_test/flutter_test.dart';
import 'package:tokio_marine/core/utils/validators.dart';

void main() {
  group('required', () {
    test('rejects blank values', () {
      expect(Validators.required('  ', field: 'Nome'), 'Nome é obrigatório');
    });

    test('accepts filled values', () {
      expect(Validators.required('Maria'), isNull);
    });
  });

  group('cpf', () {
    test('rejects empty and incomplete values', () {
      expect(Validators.cpf(''), 'Informe o CPF');
      expect(Validators.cpf('123'), 'CPF deve ter 11 dígitos');
    });

    test('accepts 11 digits with or without mask', () {
      expect(Validators.cpf('12345678901'), isNull);
      expect(Validators.cpf('123.456.789-01'), isNull);
    });
  });

  group('email', () {
    test('rejects empty and malformed values', () {
      expect(Validators.email(''), 'Informe o e-mail');
      expect(Validators.email('maria@'), 'E-mail inválido');
    });

    test('accepts a valid address', () {
      expect(Validators.email(' maria@email.com '), isNull);
    });
  });

  group('password', () {
    test('rejects empty and short values', () {
      expect(Validators.password(''), 'Informe a senha');
      expect(Validators.password('12345'), 'Mínimo de 6 caracteres');
    });

    test('accepts six or more characters', () {
      expect(Validators.password('123456'), isNull);
    });
  });
}
