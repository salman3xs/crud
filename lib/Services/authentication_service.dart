import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? _verificationId;

  Future<String> verify({required String phoneNumber}) async {
    var message;
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            message ='The provided phone number is not valid.';
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          message ='Code Sent';
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 100),
        codeAutoRetrievalTimeout: (String verificationId) {
          message = "Time out";
          _verificationId = verificationId;
        });
    return message;
  }

  Future<String> signIn({required String sms}) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: sms,
      );
      _firebaseAuth.signInWithCredential(credential);
      return 'Login Complete';
    } catch (e) {
      "Failed to sign in: " + e.toString();
      rethrow;
    }
  }
}
