import 'package:equatable/equatable.dart';

class SavedCredentials extends Equatable {
  const SavedCredentials({required this.cpf, required this.password});

  final String cpf;
  final String password;

  @override
  List<Object?> get props => [cpf, password];
}
