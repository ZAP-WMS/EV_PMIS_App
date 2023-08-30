import 'package:ev_pmis_app/Authentication/login_register.dart';
import 'package:ev_pmis_app/authentication/authservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style.dart';
import '../widgets/custom_textfield.dart';

class RegisterPge extends StatefulWidget {
  RegisterPge({super.key});

  @override
  State<RegisterPge> createState() => _RegisterPgeState();
}

class _RegisterPgeState extends State<RegisterPge> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController firstNamecontroller = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
                key: _key,
                child: Column(
                  children: [
                    _space(16),
                    CustomTextField(
                      controller: firstNamecontroller,
                      labeltext: 'First Name',
                      keyboardType: TextInputType.emailAddress,
                      validatortext: 'First Name is Required',
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: lastNameController,
                      labeltext: 'Last Name',
                      keyboardType: TextInputType.emailAddress,
                      validatortext: 'Last Name is Required',
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: numberController,
                      labeltext: 'Mobile Number',
                      keyboardType: TextInputType.emailAddress,
                      validatortext: 'Mobile Number is Required',
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: emailIdController,
                      labeltext: 'Email ID',
                      keyboardType: TextInputType.emailAddress,
                      validatortext: 'Email ID is Required',
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: designationController,
                      labeltext: 'Designation',
                      keyboardType: TextInputType.text,
                      validatortext: 'Designation is Required',
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: departmentController,
                      labeltext: 'Department',
                      keyboardType: TextInputType.text,
                      validatortext: 'Department is Required',
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: passwordController,
                      labeltext: 'Password',
                      validatortext: 'Password is Required',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: confController,
                      labeltext: 'Confirm Password',
                      validatortext: 'Confirm Password is Required',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                    _space(16),
                    SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              register();
                            },
                            child: const Text('Register'))),
                    _space(16),
                    Image.asset(
                      'assets/Tata-Power.jpeg',
                      height: 150,
                      width: 200,
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }

  void register() async {
    if (_key.currentState!.validate()) {
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
      await AuthService()
          .registerUserWithEmailAndPassword(
              firstNamecontroller.text,
              lastNameController.text,
              numberController.text,
              emailIdController.text,
              designationController.text,
              departmentController.text,
              passwordController.text,
              confController.text)
          .then((value) {
        if (value == true) {
          AuthService()
              .storeDataInFirestore(
                  firstNamecontroller.text,
                  lastNameController.text,
                  numberController.text,
                  emailIdController.text,
                  designationController.text,
                  departmentController.text,
                  passwordController.text,
                  confController.text,
                  firstNamecontroller.text[0] +
                      lastNameController.text[0] +
                      numberController.text.substring(6, 10))
              .then((value) {
            if (value == true) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Registration Successfull Please Sign In'),
                backgroundColor: blue,
              ));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginRegister()),
              );
            } else {
              Navigator.pop(context);
              //     authService.firebaseauth.signOut();
            }
          });
        } else {
          Navigator.of(context).pop();
        }
      });
    }
  }
}

checkFieldEmpty(String fieldContent, String errMsg) {
  if (fieldContent.isEmpty) {
    return '$errMsg is Required';
  }
  return null;
}
