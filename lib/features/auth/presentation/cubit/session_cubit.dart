import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/watch_current_user.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit({required this._watchCurrentUser, required this._signOut})
    : super(const SessionState.unknown());

  final WatchCurrentUser _watchCurrentUser;
  final SignOut _signOut;
  StreamSubscription<AppUser?>? _subscription;

  Future<void> start() async {
    await _subscription?.cancel();
    final firstEvent = Completer<void>();
    _subscription = _watchCurrentUser().listen((user) {
      emit(
        user == null
            ? const SessionState.unauthenticated()
            : SessionState.authenticated(user),
      );
      if (!firstEvent.isCompleted) firstEvent.complete();
    });
    return firstEvent.future;
  }

  Future<void> signOut() => _signOut();

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
