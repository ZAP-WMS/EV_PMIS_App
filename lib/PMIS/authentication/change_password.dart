import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/authentication/register_page.dart';

import 'package:flutter/material.dart';

import '../widgets/custom_textfield.dart';

class ChangePassword extends StatefulWidget {
  String name;
  final int mobileNumber;
  ChangePassword({super.key, required this.name, required this.mobileNumber});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomTextField(
          controller: passwordController,
          labeltext: 'Password',
          validatortext: (value) {
            return validatePassword(value!);
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          isSuffixIcon: false,
        ),
        _space(16),
        CustomTextField(
          controller: confController,
          labeltext: 'Confirm Password',
          validatortext: (value) {
            return validateConfirmPassword(
                passwordController.text, confController.text);
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          isSuffixIcon: false,
        ),
        ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("User")
                  .doc(widget.name)
                  .update({
                'Password': passwordController.text,
                'ConfirmPassword': confController.text
              });
            },
            child: const Text('Submit'))
      ]),
    );
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }
}
