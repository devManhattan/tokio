import 'package:mocktail/mocktail.dart';
import 'package:tokio_marine/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tokio_marine/features/auth/domain/repositories/auth_repository.dart';
import 'package:tokio_marine/features/auth/domain/repositories/credentials_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCredentialsRepository extends Mock implements CredentialsRepository {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
