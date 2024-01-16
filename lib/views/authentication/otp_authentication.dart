import 'package:firebase_auth/firebase_auth.dart';

List<int>? getCode;
Future<void> verifyPhoneNumber(String phoneNumber) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: '+919619080687',
    verificationCompleted: (PhoneAuthCredential credential) async {
      // This callback will be called if the phone number is instantly verified.
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      // Handle verification failed scenario.
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      // Save the verification ID somewhere, and use it to handle user input.
    // Update the UI - wait for the user to enter the SMS code
    String smsCode = 'xxxx';

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await auth.signInWithCredential(credential);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Called when the automatic verification process times out.
    },
    timeout: const Duration(
        seconds: 60), // Timeout duration for automatic code retrieval.
    // verificationId: verificationId, // Pass the verification ID to this callback.
  );
}
