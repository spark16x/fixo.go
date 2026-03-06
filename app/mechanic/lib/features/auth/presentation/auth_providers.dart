import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authProvider).authStateChanges();
});

final profileExistsProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;

  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return doc.exists && doc.data()?['role'] == 'mechanic';
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(authProvider));
});

class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;

  Future<void> signInOrRegister(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found' || error.code == 'invalid-credential') {
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
      } else {
        rethrow;
      }
    }
  }
}
