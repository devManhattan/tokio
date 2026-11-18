import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';
import 'auth_remote_data_source.dart';

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _cpfs =>
      _firestore.collection('cpfs');

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Stream<AppUser?> watchUser() {
    return _auth.userChanges().map(
      (user) => user == null
          ? null
          : AppUser(
              id: user.uid,
              name: user.displayName ?? '',
              email: user.email ?? '',
            ),
    );
  }

  @override
  Future<String?> findEmailByCpf(String cpf) async {
    final snapshot = await _cpfs.doc(cpf).get();
    return snapshot.data()?['email'] as String?;
  }

  @override
  Future<void> signIn({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> createAccount({
    required String name,
    required String cpf,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;

    try {
      await (_firestore.batch()
            ..set(_cpfs.doc(cpf), {'email': email, 'uid': user.uid})
            ..set(_users.doc(user.uid), {
              'name': name,
              'cpf': cpf,
              'email': email,
            }))
          .commit();
      await user.updateDisplayName(name);
    } catch (_) {
      await user.delete();
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
