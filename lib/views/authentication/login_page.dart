import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/views/authentication/reset_password.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isUser = false;
  String role = "";
  String projectManagerName = '';
  String adminName = '';
  bool isProjectManager = false;
  bool isAdmin = false;
  late SharedPreferences _sharedPreferences;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController empIdController = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  bool _isHidden = true;
  AuthService authService = AuthService();

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
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      isSuffixIcon: false,

                      validatortext: (value) {
                        return checkFieldEmpty(
                            value!, 'Employee ID is Required');
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
                      isSuffixIcon: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                    ),
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
                                          builder: (context) => ResetPass(
                                              // email: FirebaseAuth
                                              //     .instance
                                              //     .currentUser!
                                              //     .email!,
                                              )))),
                                style: const TextStyle(color: Colors.blue))
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
      String companyName = '';

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    color: blue,
                  ),
                ),
              ),
              Text(
                'Verifying..',
                style: TextStyle(color: blue, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );

      try {
        isProjectManager = await verifyProjectManager(empIdController.text);

        if (isProjectManager == true) {
          QuerySnapshot pmData = await FirebaseFirestore.instance
              .collection('AssignedRole')
              .where("userId", isEqualTo: empIdController.text)
              .get();

          //Search project Manager On User Collection

          if (pmData.docs.isNotEmpty) {
            List<dynamic> userData = pmData.docs.map((e) => e.data()).toList();
            companyName = 'TATA POWER';
            if (passwordcontroller.text == userData[0]['password'] &&
                empIdController.text == userData[0]['userId']) {
              List<dynamic> assignedDepots = pmData.docs[0]["depots"];

              List<String> depots =
                  assignedDepots.map((e) => e.toString()).toList();
              // print('ProjectManager here ${passWord}');
              authService.storeUserRole("projectManager");
              await authService.storeDepoList(depots);
              authService.storeEmployeeId(empIdController.text.trim());
              authService.storeCompanyName(companyName).then((_) {
                Navigator.pushReplacementNamed(context, '/splitDashboard',
                    arguments: {
                      'userId': empIdController.text,
                      "role": "projectManager"
                    });
              });
            }
          }
        } else {
          isAdmin = await verifyAdmin(empIdController.text);
          //Login as an admin

          if (!isAdmin) {
            //Login as a user

            QuerySnapshot userQuery = await FirebaseFirestore.instance
                .collection('AssignedRole')
                .where('userId', isEqualTo: empIdController.text)
                .get();

            if (passwordcontroller.text == userQuery.docs[0]['password'] &&
                empIdController.text == userQuery.docs[0]['userId'] &&
                userQuery.docs.isNotEmpty) {
              List<dynamic> assignedDepots = userQuery.docs[0]["depots"];
              List<String> depots =
                  assignedDepots.map((e) => e.toString()).toList();
              await authService.storeUserRole("user");
              await authService.storeCompanyName(companyName);
              await authService.storeDepoList(depots);
              authService.storeEmployeeId(empIdController.text).then((_) {
                Navigator.pushReplacementNamed(context, '/splitDashboard',
                    arguments: {
                      'userId': empIdController.text,
                      "role": "user"
                    });
              });
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Password is not Correct or no roles are assigned to this user'),
                ),
              );
            }
          }
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        String error = '';
        if (e.toString() ==
            'RangeError (index): Invalid value: Valid value range is empty: 0') {
          error = 'Employee Id does not exist!';
        } else {
          error = e.toString();
        }
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: blue,
        ));
      }
    }
  }

  Future<bool> verifyAdmin(String userId) async {
    bool userIsAdmin = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('userId', isEqualTo: userId)
        .get();

    List<dynamic> dataList = querySnapshot.docs.map((e) => e.data()).toList();

    if (dataList.isNotEmpty) {
      adminName = dataList[0]['username'];
      List<dynamic> rolesList = dataList[0]['roles'];

      if (rolesList.contains("Admin")) {
        userIsAdmin = true;
      }

      if (userIsAdmin) {
        String companyName = dataList[0]['companyName'];
        if (passwordcontroller.text.trim() == dataList[0]['password'] &&
            empIdController.text.trim() == dataList[0]['userId'] &&
            dataList[0]['companyName'] == 'TATA POWER') {
          List<dynamic> assignedDepots = querySnapshot.docs[0]["depots"];
          List<String> depots =
              assignedDepots.map((e) => e.toString()).toList();
          authService.storeUserRole("admin");
          await authService.storeDepoList(depots);

          authService.storeCompanyName(companyName);
          authService.storeEmployeeId(empIdController.text.trim()).then((_) {
            Navigator.pushReplacementNamed(context, '/splitDashboard',
                arguments: {
                  'userId': empIdController.text.trim(),
                  "role": "admin"
                });
          });
        } else if (passwordcontroller.text == dataList[0]['password'] &&
            empIdController.text.trim() == dataList[0]['userId'] &&
            dataList[0]['companyName'] == 'TATA MOTOR') {
          authService.storeCompanyName(companyName);
          authService.storeEmployeeId(empIdController.text.trim()).then((_) {
            Navigator.pushReplacementNamed(context, '/splitDashboard',
                arguments: {
                  'userId': empIdController.text.trim(),
                  "role": "admin"
                });
          });
        }
      }
    }
    return userIsAdmin;
  }

  Future<bool> verifyProjectManager(String userId) async {
    bool userIsProjectManager = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('userId', isEqualTo: userId)
        .get();

    List<dynamic> dataList = querySnapshot.docs.map((e) => e.data()).toList();

    if (dataList.isNotEmpty) {
      projectManagerName = dataList[0]['username'];
      List<dynamic> rolesList = dataList[0]['roles'];

      rolesList.every(
        (element) {
          if (element == 'Project Manager') {
            userIsProjectManager = true;
          }
          return false;
        },
      );
    }

    return userIsProjectManager;
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
