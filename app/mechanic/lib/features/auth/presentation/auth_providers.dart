import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);
final authStateProvider = StreamProvider<User?>((ref) => ref.read(authProvider).authStateChanges());

final profileExistsProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;
  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return doc.exists && doc.data()?['role'] == 'mechanic';
});

final otpServiceProvider = Provider((ref) => _OtpService(ref.read(authProvider)));

class _OtpService {
  _OtpService(this._auth);
  final FirebaseAuth _auth;

  Future<String> sendOtp(String phone) async {
    final completer = Completer<String>();
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async => _auth.signInWithCredential(credential),
      verificationFailed: completer.completeError,
      codeSent: (verificationId, _) => completer.complete(verificationId),
      codeAutoRetrievalTimeout: (verificationId) {
        if (!completer.isCompleted) completer.complete(verificationId);
      },
    );
    return completer.future;
  }

  Future<void> verify(String verificationId, String code) {
    final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    return _auth.signInWithCredential(credential);
  }
}
