import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationService with ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? _verificationId;

  Future<void> verifyPhone(String countryCode, String mobile) async {
    var mobileToSend = mobile;
    final PhoneCodeSent smsOTPSent = (String verId, [int? forceCodeResend]) {
      this._verificationId = verId;
    };
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: countryCode+ mobileToSend,
          codeAutoRetrievalTimeout: (String verId) {
            this._verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(
            seconds: 120,
          ),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exceptio) {
            throw exceptio;
          });
    } catch (e) {
      throw e;
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
      final User currentUser = _firebaseAuth.currentUser!;
      print(currentUser);

      if (currentUser.uid != "") {
        print(currentUser.uid);
      }
    } catch (e) {
      throw e;
    }
  }

  showError(error) {
    throw error.toString();
  }
}
