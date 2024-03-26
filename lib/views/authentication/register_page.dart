import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../style.dart';
import '../../widgets/custom_textfield.dart';
import 'login_register.dart';

class RegisterPge extends StatefulWidget {
  RegisterPge({super.key});

  @override
  State<RegisterPge> createState() => _RegisterPgeState();
}

class _RegisterPgeState extends State<RegisterPge> {
  final _formkey = GlobalKey<FormState>();
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
                key: _formkey,
                child: Column(
                  children: [
                    _space(
                      16,
                    ),
                    CustomTextField(
                      controller: firstNamecontroller,
                      labeltext: 'First Name',
                      keyboardType: TextInputType.emailAddress,
                      isSuffixIcon: false,
                      validatortext: (value) {
                        return validateField(
                            firstNamecontroller.text, 'First Name is Required',);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    _space(
                      16,
                    ),
                    CustomTextField(
                      controller: lastNameController,
                      labeltext: 'Last Name',
                      keyboardType: TextInputType.emailAddress,
                      isSuffixIcon: false,
                      validatortext: (value) {
                        return validateField(
                            lastNameController.text, 'Last Name is Required',);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: numberController,
                      labeltext: 'Mobile Number',
                      keyboardType: TextInputType.emailAddress,
                      isSuffixIcon: false,
                      validatortext: (value) {
                        return validateNumber(value);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: emailIdController,
                      labeltext: 'Email ID',
                      keyboardType: TextInputType.emailAddress,
                      isSuffixIcon: false,
                      validatortext: (value) {
                        return validateEmail(value!);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: designationController,
                      labeltext: 'Designation',
                      keyboardType: TextInputType.text,
                      isSuffixIcon: false,
                      validatortext: (value) {
                        return validateField(value!, 'Designation is Required');
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: departmentController,
                      labeltext: 'Department',
                      keyboardType: TextInputType.text,
                      isSuffixIcon: false,
                      validatortext: (value) {
                        return validateField(
                            value!, 'Department Name is Required');
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    _space(16),
                    CustomTextField(
                      controller: passwordController,
                      labeltext: 'Password',
                      validatortext: (value) {
                        return validatePassword(value!);
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      isSuffixIcon: true,
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
                      isSuffixIcon: true,
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
              _showRegistrationDialog(
                  context,
                  firstNamecontroller.text[0] +
                      lastNameController.text[0] +
                      numberController.text.substring(6, 10),
                  confController.text);
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

  String? validateField(String fieldContent, String errMsg) {
    if (fieldContent.isEmpty) {
      return errMsg;
    }
    return null;
  }
}

String? validateEmail(String value) {
  // Check if the email is empty
  if (value.isEmpty) {
    return 'Email address is required';
  }

  // Use a regular expression to validate the email format
  String emailRegex = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+(\.[a-zA-Z]+)?$';
  RegExp regex = RegExp(emailRegex);
  if (!regex.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  // Return null if the input is valid
  return null;
}

String? validatePassword(String value) {
  // Check if the password is empty
  if (value.isEmpty) {
    return 'Password is required';
  }

  if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
      .hasMatch(value)) {
    return 'Password should be 8 caharecter & at least one upper case , contain alphabate , numbers & special character';
  }
  return null;

  // Return null if the input is valid
}

String? validateConfirmPassword(String password, String confirmPassword) {
  // Check if the confirm password is empty
  if (confirmPassword.isEmpty) {
    return 'Confirm password is required';
  }

  // Check if the confirm password matches the original password
  if (password != confirmPassword) {
    return 'Passwords do not match';
  }

  // Return null if the input is valid
  return null;
}

String? validateNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Mobile number is required';
  }
  // Regular expression to match a valid mobile phone number
  String pattern = r'^(?:[+0]9)?[0-9]{10}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Invalid mobile number';
  }
  return null;
}

void _showRegistrationDialog(
    BuildContext context, dynamic userId, dynamic pass) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          height: 300,
          width: 600,
          child: AlertDialog(
            title: const Text(
              'Please Remember Your Login Details',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Your User ID: '),
                    Text(
                      userId,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Your Password: '),
                    Text(
                      pass,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
