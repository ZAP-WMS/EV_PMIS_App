import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/authentication/register_page.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextFormField(
              //   controller: _currentPasswordController,
              //   obscureText: true,
              //   decoration: InputDecoration(labelText: 'Current Password'),
              // ),
              // SizedBox(height: 16.0),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  return validatePassword(value!);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm New Password'),
                validator: (value) {
                  return validateConfirmPassword(_newPasswordController.text,
                      _confirmNewPasswordController.text);
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: blue),
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
}
