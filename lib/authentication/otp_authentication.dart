import 'package:firebase_auth/firebase_auth.dart';

List<int>? getCode;
Future<void> verifyPhoneNumber(String phoneNumber) async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {
      // This callback will be called if the phone number is instantly verified.
    },
    verificationFailed: (FirebaseAuthException e) {
      // Handle verification failed scenario.
    },
    codeSent: (String verificationId, int? resendToken) async {
      // Save the verification ID somewhere, and use it to handle user input.
      String smsCode = '';
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Called when the automatic verification process times out.
    },
    timeout: const Duration(
        seconds: 60), // Timeout duration for automatic code retrieval.
    // verificationId: verificationId, // Pass the verification ID to this callback.
  );
}
