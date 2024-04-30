import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/views/authentication/reset_password.dart';
import 'package:ev_pmis_app/widgets/custom_alert_box.dart';
import 'package:ev_pmis_app/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    return WillPopScope(
      onWillPop: () async {
        CustomAlertBox()
            .customLogOut(context, 'Do you want to Exit ?', '', true);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: SingleChildScrollView(
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      _space(
                        16,
                      ),
                      CustomTextField(
                        isFieldEditable: true,
                        controller: empIdController,
                        labeltext: 'Employee ID',
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
                        isFieldEditable: true,
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
                                            builder: (context) => ResetPass(),
                                          ),
                                        )),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                          ),
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
                          child: const Text(
                            'Sign In',
                          ),
                        ),
                      ),

                      // Text("Project Management Information System",
                      //     style: headlineBold),
                      // Text(" EV Monitoring ", style: headlineBold),
                      Image.asset(
                        'assets/Tata-Power.jpeg',
                        height: 150,
                        width: 200,
                      ),
                      Text(
                        "Project Management Information System",
                        textAlign: TextAlign.center,
                        style: headlineBold,
                      ),
                    ],
                  )),
            ),
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
        isProjectManager =
            await verifyAndLoginProjectManager(empIdController.text);

        if (isProjectManager == false) {
          isAdmin = await verifyAndLoginAdmin(empIdController.text);
        } else if (isAdmin == false && isProjectManager == false) {
          verifyAndLoginUser();
        }
      } catch (e) {
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

  Future verifyAndLoginUser() async {
    QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('userId', isEqualTo: empIdController.text)
        .get();

    if (passwordcontroller.text == userQuery.docs[0]['password'] &&
        empIdController.text == userQuery.docs[0]['userId'] &&
        userQuery.docs.isNotEmpty) {
      String roleCentre = userQuery.docs[0]['roleCentre'];
      String companyName = userQuery.docs[0]['companyName'];
      List<dynamic> assignedDepots = userQuery.docs[0]["depots"];
      List<dynamic> assignedCities = userQuery.docs[0]["cities"];

      List<String> cities = assignedCities.map((e) => e.toString()).toList();
      authService.storeCityList(cities);
      List<String> depots = assignedDepots.map((e) => e.toString()).toList();
      authService.storeUserRole("user");
      authService.storeCompanyName(companyName);
      authService.storeDepoList(depots);
      authService.storeRoleCentre(roleCentre);
      authService.storeEmployeeId(empIdController.text).then((_) {
        Navigator.pushReplacementNamed(
          context,
          // '/splitDashboard',
          '/main_screen',
          arguments: {
            "roleCentre": roleCentre,
            'userId': empIdController.text,
            "role": "user"
          },
        );
      });
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: blue,
          content: const Text(
              'Password is not Correct or no role is assigned to the user'),
        ),
      );
    }
  }

  Future<bool> verifyAndLoginAdmin(String userId) async {
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
          String roleCentre = dataList[0]['roleCentre'];
          List<dynamic> assignedDepots = querySnapshot.docs[0]["depots"];
          List<dynamic> assignedCities = querySnapshot.docs[0]["cities"];
          List<String> cities =
              assignedCities.map((e) => e.toString()).toList();
          authService.storeCityList(cities);
          List<String> depots =
              assignedDepots.map((e) => e.toString()).toList();
          authService.storeUserRole("admin");
          authService.storeDepoList(depots);
          authService.storeCompanyName(companyName);
          authService.storeRoleCentre(roleCentre);
          authService.storeEmployeeId(empIdController.text.trim()).then((_) {
            Navigator.pushReplacementNamed(context, '/main_screen', arguments: {
              "roleCentre": roleCentre,
              'userId': empIdController.text.trim(),
              "role": "admin"
            });
          });
        } else if (passwordcontroller.text == dataList[0]['password'] &&
            empIdController.text.trim() == dataList[0]['userId'] &&
            dataList[0]['companyName'] == 'TATA MOTOR') {
          String roleCentre = dataList[0]['roleCentre'];
          List<dynamic> assignedDepots = querySnapshot.docs[0]["depots"];
          List<dynamic> assignedCities = querySnapshot.docs[0]["cities"];
          List<String> cities =
              assignedCities.map((e) => e.toString()).toList();
          authService.storeCityList(cities);
          List<String> depots =
              assignedDepots.map((e) => e.toString()).toList();

          authService.storeUserRole("admin");
          authService.storeRoleCentre(roleCentre);
          await authService.storeDepoList(depots);
          authService.storeCompanyName(companyName);
          authService.storeEmployeeId(empIdController.text.trim()).then((_) {
            Navigator.pushReplacementNamed(context, '/main_screen', arguments: {
              "roleCentre": roleCentre,
              'userId': empIdController.text.trim(),
              "role": "admin"
            });
          });
        }
      }
    }
    return userIsAdmin;
  }

  Future<bool> verifyAndLoginProjectManager(String userId) async {
    bool userIsProjectManager = false;
    String companyName = '';
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

    if (userIsProjectManager) {
      QuerySnapshot pmData = await FirebaseFirestore.instance
          .collection('AssignedRole')
          .where("userId", isEqualTo: empIdController.text)
          .get();

      //Search project Manager On User Collection

      if (pmData.docs.isNotEmpty) {
        List<dynamic> userData = pmData.docs.map((e) => e.data()).toList();
        companyName = userData[0]["companyName"];
        if (passwordcontroller.text == userData[0]['password'] &&
            empIdController.text == userData[0]['userId']) {
          String roleCentre = userData[0]["roleCentre"];
          List<dynamic> assignedDepots = pmData.docs[0]["depots"];
          List<dynamic> assignedCities = pmData.docs[0]["cities"];
          List<String> cities =
              assignedCities.map((e) => e.toString()).toList();
          authService.storeCityList(cities);
          List<String> depots =
              assignedDepots.map((e) => e.toString()).toList();

          // print('ProjectManager here ${passWord}');
          authService.storeUserRole("projectManager");
          authService.storeDepoList(depots);
          authService.storeEmployeeId(empIdController.text.trim());
          authService.storeRoleCentre(roleCentre);
          authService.storeCompanyName(companyName).then((_) {
            Navigator.pushReplacementNamed(
              context, '/main_screen', arguments: {
              "roleCentre": roleCentre,
              'userId': empIdController.text,
              "role": "projectManager"
            }
            );
          });
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: blue,
              content: const Text(
                  'Password is not Correct or no role is assigned to the user'),
            ),
          );
        }
      }
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
