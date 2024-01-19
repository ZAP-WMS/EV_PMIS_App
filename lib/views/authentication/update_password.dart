import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/authentication/register_page.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
  String docName;
  UpdatePassword({
    Key? key,
    required this.docName,
  }) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  // final TextEditingController _currentPasswordController =
  //     TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Update Password',
          height: 50,
          isSync: false,
          isCentered: true),
      // AppBar(
      //   title: Text('Update Password'),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                  controller: _newPasswordController,
                  labeltext: 'New Password',
                  isSuffixIcon: true,
                  validatortext: (value) {
                    return validatePassword(value!);
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next),
              const SizedBox(height: 20.0),
              CustomTextField(
                  controller: _confirmNewPasswordController,
                  labeltext: 'Confirm New Password',
                  isSuffixIcon: true,
                  validatortext: (value) {
                    return validatePassword(value!);
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next),
              const SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Border radius
                  ),
                  backgroundColor: blue,
                ),
                onPressed: () {
                  // Add your password update logic here
                  // Validate input, check if new password and confirm new password match, etc.
                  // Then, trigger the password update action
                  updatePassword();
                },
                child: const Text('Update Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePassword() async {
    if (_formkey.currentState!.validate()) {
      // Implement your password update logic here
      // String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;
      String confirmNewPassword = _confirmNewPasswordController.text;
      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection('User')
      //     .where('EmployeeId', isEqualTo: 'ZW3210')
      //     .get();
      // print(querySnapshot.docs.first.id);
      // Add validation and password update logic
      if (newPassword == confirmNewPassword) {
        // Perform password update action
        // For example, use FirebaseAuth.instance.currentUser.updatePassword(newPassword);
        FirebaseFirestore.instance.collection('User').doc('ZAP WMS').update({
          'Password': newPassword,
          'ConfirmPassword': confirmNewPassword,
        }).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Your password is updated Successfully')));
          Navigator.pushReplacementNamed(context, '/login-page');
        });
        // Handle success or failure accordingly
        print('Password updated successfully');
      } else {
        // Passwords do not match, show an error message
        print('New password and confirm new password do not match');
      }
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
