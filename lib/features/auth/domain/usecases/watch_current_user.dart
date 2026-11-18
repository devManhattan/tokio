import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class WatchCurrentUser {
  const WatchCurrentUser(this._authRepository);

  final AuthRepository _authRepository;

  Stream<AppUser?> call() => _authRepository.watchUser();
}
