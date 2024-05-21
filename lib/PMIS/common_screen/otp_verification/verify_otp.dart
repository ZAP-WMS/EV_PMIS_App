import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class VerifiyOtp extends StatefulWidget {
  String? verificationId;

  VerifiyOtp({super.key, this.verificationId});

  @override
  State<VerifiyOtp> createState() => _VerifiyOtpState();
}

class _VerifiyOtpState extends State<VerifiyOtp> {
  String otpCode = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter OTP',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              otpCode = _otpController.text.toString().trim();
              verifyOtp();
            },
            child: const Text('Verify OTP'),
          )
        ],
      ),
    );
  }

  Future<void> verifyOtp() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget
            .verificationId!, // You should have the verificationId from Firebase
        smsCode: otpCode,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // OTP is verified, and user is signed in
        // Navigate to the next screen after successful verification
        Navigator.pushNamed(context, '/login-page');
      } else {
        // Handle verification failure
        print("Error verifying OTP");
      }
    } catch (e) {
      // Handle verification failure (e.g., wrong OTP)
      print("Error verifying OTP: $e");
    }
  }
}
