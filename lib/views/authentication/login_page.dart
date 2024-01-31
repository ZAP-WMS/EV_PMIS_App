import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/authentication/check_otp.dart';
import 'package:ev_pmis_app/views/authentication/reset_password.dart';
import 'package:ev_pmis_app/views/authentication/update_password.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared_preferences/shared_preferences.dart';
import '../../style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isUser = false;
  String role = "";
  late SharedPreferences _sharedPreferences;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController empIdController = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    _space(16),
                    CustomTextField(
                      controller: empIdController,
                      labeltext: 'Employee ID',
                      // validator: checkFieldEmpty(
                      //     empIdController.text, 'Employee Id is required'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      isSuffixIcon: false,
                      validatortext: (value) {
                        return checkFieldEmpty(value!, 'Email is Required');
                      },
                    ),
                    _space(16),
                    CustomTextField(
                        controller: passwordcontroller,
                        labeltext: 'Password',
                        validatortext: (value) {
                          return checkFieldEmpty(
                              passwordcontroller.text, 'Password is Required');
                        },
                        keyboardType: TextInputType.visiblePassword,
                        isSuffixIcon: true,
                        textInputAction: TextInputAction.done),
                    _space(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RichText(
                            text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Forget Password ?',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = (() => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            // UpdatePassword(
                                            //       docName: '',
                                            //     )
                                            // CheckOtp(
                                            //     name: '',
                                            //     mobileNumber: 9321327107)
                                            ResetPass(),
                                      ))),
                                style: TextStyle(color: blue))
                          ],
                        )),
                      ],
                    ),
                    _space(16),
                    SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              login();
                              // Navigator.pushNamedAndRemoveUntil(
                              //     context, '/gallery', (route) => false);
                              // Navigator.pushNamed(context, '/first');
                            },
                            child: const Text('Sign In'))),

                    // Text("Project Management Information System",
                    //     style: headlineBold),
                    // Text(" EV Monitoring ", style: headlineBold),
                    Image.asset(
                      'assets/Tata-Power.jpeg',
                      height: 150,
                      width: 200,
                    ),
                    Text("Project Management Information System",
                        textAlign: TextAlign.center, style: headlineBold),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  checkFieldEmpty(String fieldContent, String title) {
    if (fieldContent.isEmpty) return title;
    return null;
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }

  login() async {
    if (_formkey.currentState!.validate()) {
      showCupertinoDialog(
        context: context,
        builder: (context) => const CupertinoAlertDialog(
          content: SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      await checkRole();
      await StoredDataPreferences.saveString('role', role);

      QuerySnapshot snap = isUser
          ? await FirebaseFirestore.instance
              .collection('User')
              .where('Employee Id', isEqualTo: empIdController.text)
              .get()
          : await FirebaseFirestore.instance
              .collection('Admin')
              .where('Employee Id', isEqualTo: empIdController.text)
              .get();

      try {
        if (passwordcontroller.text == snap.docs[0]['Password'] &&
            empIdController.text == snap.docs[0]['Employee Id']) {
          _sharedPreferences = await SharedPreferences.getInstance();
          _sharedPreferences
              .setString('employeeId', empIdController.text)
              .then((_) {
            Navigator.pushReplacementNamed(context, '/gallery');
          });
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password is not correct')));
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        String error = '';
        if (e.toString() ==
            'RangeError (index): Invalid value: Valid value range is empty: 0') {
          setState(() {
            error = 'Employee Id does not exist!';
          });
        } else {
          setState(() {
            error = 'Error occured!';
          });
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  Future<String> checkRole() async {
    try {
      QuerySnapshot checkAdmin = await FirebaseFirestore.instance
          .collection('Admin')
          .where('Employee Id', isEqualTo: empIdController.text)
          .get();

      if (checkAdmin.docs.isNotEmpty) {
        role = 'admin';
        isUser = false;
      } else {
        QuerySnapshot checkUser = await FirebaseFirestore.instance
            .collection('User')
            .where('Employee Id', isEqualTo: empIdController.text)
            .get();

        if (checkUser.docs.isNotEmpty) {
          role = 'user';
          isUser = true;
        }
      }
      print(role);

      return role;
    } catch (e) {
      print('Error Occured while checking role - $e');
      return role;
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
