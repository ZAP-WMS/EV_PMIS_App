import 'package:ev_pmis_app/views/authentication/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import '../../style.dart';
import 'otp_authentication.dart';

class CheckOtp extends StatefulWidget {
  String name;
  final int mobileNumber;
  CheckOtp({Key? key, required this.name, required this.mobileNumber})
      : super(key: key);

  @override
  State<CheckOtp> createState() => _CheckOtpState();
}

class _CheckOtpState extends State<CheckOtp> {
  @override
  void initState() {
    super.initState();

    // FirebaseAuth.instance.sendPasswordResetEmail(email: widget.mobileNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            //         SvgPicture.asset('Assets/icon/yt.svg', width: 128, height: 128),
            const SizedBox(height: 20),
            SizedBox(
              width: 265,
              child: Text('Check your mobile',
                  style: TextStyle(color: black, fontSize: 25),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 282,
              child: Text(
                  'We have sent an otp to ${widget.mobileNumber} with a link to get back into your account ',
                  style: TextStyle(color: black, fontSize: 14),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 40),

            OTPInputBox(),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text('Skip, I\'ll confirm later',
                  style: headlineblack, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 70),
            Text('Did not receive the otp? ',
                style: headlineblack, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text('or ', style: TextStyle(color: black, fontSize: 14)),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text('Send again',
                      style: TextStyle(color: blue, fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OTPInputBox extends StatefulWidget {
  @override
  _OTPInputBoxState createState() => _OTPInputBoxState();
}

class _OTPInputBoxState extends State<OTPInputBox> {
  TextEditingController _pinEditingController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  String? smscode;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          PinInputTextField(
            pinLength: 6, // You can change the length of the OTP
            decoration: BoxLooseDecoration(
              strokeColorBuilder:
                  PinListenColorBuilder(Colors.black, Colors.blue),
              radius: const Radius.circular(8),
            ),
            controller: _pinEditingController,
            autoFocus: true,
            textInputAction: TextInputAction.done,
            onChanged: (pin) {
              // You can handle the entered OTP here
              pin = _pinEditingController.text;
              print(pin);
            },
            onSubmit: (pin) {
              // Triggered when the user submits the OTP
              smscode = pin;
              setState(() {});
            },
          ),
          ElevatedButton(
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: ResetPass.verify, smsCode: smscode!);

                // Sign the user in (or link) with the credential
                await auth.signInWithCredential(credential);
              },
              child: const Text('Verify User ID'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pinEditingController.dispose();
    super.dispose();
  }
}
