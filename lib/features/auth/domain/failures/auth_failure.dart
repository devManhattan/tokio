import 'package:equatable/equatable.dart';

enum AuthFailureType {
  invalidCredentials,
  cpfAlreadyInUse,
  cpfNotFound,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  network,
  tooManyRequests,
  unknown,
}

class AuthFailure extends Equatable implements Exception {
  const AuthFailure(this.type);

  final AuthFailureType type;

  @override
  List<Object?> get props => [type];
}
