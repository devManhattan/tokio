import 'package:equatable/equatable.dart';

import '../../domain/entities/app_user.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionState extends Equatable {
  const SessionState.unknown() : this._(SessionStatus.unknown);

  const SessionState.authenticated(AppUser user)
    : this._(SessionStatus.authenticated, user);

  const SessionState.unauthenticated() : this._(SessionStatus.unauthenticated);

  const SessionState._(this.status, [this.user]);

  final SessionStatus status;
  final AppUser? user;

  @override
  List<Object?> get props => [status, user];
}
