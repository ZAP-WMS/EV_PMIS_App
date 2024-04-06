import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../style.dart';

import 'check_otp.dart';
import 'otp_authentication.dart';

class ResetPass extends StatefulWidget {
  // final String email;
  ResetPass({
    Key? key,
    // required this.email,
  }) : super(key: key);

  static String verify = '';

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  FocusNode? _focusNode;
  TextEditingController textEditingController = TextEditingController();
  List docss = [];
  var temp;
  String? mobileNum;
  String? name;
  String? lastName;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode!.addListener(_onOnFocusNodeEvent);
    // if (RegExp(
    //         r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
    //     .hasMatch(textEditingController.text)) ;
    // textEditingController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Reset Password',
          style: TextStyle(color: black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reset Password', style: headlineblack),
              const SizedBox(height: 20),
              Text(
                'Enter the User Id associated with your account and we\'ll send an otp with instructions to reset your password',
                style: bodyTextblack,
              ),
              const SizedBox(height: 80),
              TextField(
                controller: textEditingController,
                focusNode: _focusNode,
                style: bodyTextblack,
                decoration: InputDecoration(
                    fillColor: _focusNode!.hasFocus ? Colors.white : white,
                    filled: true,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: black)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: black,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    labelText: _focusNode!.hasFocus ? 'User ID' : null,
                    labelStyle: _focusNode!.hasFocus ? bodytext : null,
                    hintText: _focusNode!.hasFocus ? null : 'User ID',
                    hintStyle: bodyTextblack),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      minimumSize: MediaQuery.of(context).size,
                      backgroundColor: blue,
                    ),
                    onPressed: () {
                      if (textEditingController.text.isNotEmpty) {
                        getNumber(textEditingController.text)
                            .whenComplete(() async {
                          print('mobile number$mobileNum');
                          if (mobileNum != null) {
                            // verifyPhoneNumber('+91$mobileNum');
                            await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: '+91$mobileNum',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed: (FirebaseAuthException e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: red,
                                  ));
                                },
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  ResetPass.verify = verificationId;
                                  print('verifycode${ResetPass.verify}');
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckOtp(
                                              name: '${name!} ' '${lastName!}',
                                              mobileNumber:
                                                  int.parse(mobileNum!))));
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {});

                            // ignore: use_build_context_synchronously
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  "We could not find your ID. Please check once to ensure it is correct."),
                              backgroundColor: red,
                            ));
                          }
                        });
                      } else {
                        // ignore: prefer_const_constructors
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('User Id is required'),
                        ));
                      }
                    },
                    child: Text('Send',
                        style: TextStyle(
                            fontSize: 14,
                            color: white,
                            fontWeight: FontWeight.w500))),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  Future getNumber(dynamic id) async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: SizedBox(
          height: 120,
          width: 50,
          child: Center(
            child: Column(
              children: const [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(height: 10),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text('Wait We are verifying your Id')
              ],
            ),
          ),
        ),
      ),
    );
    String? clnName;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('User').get();
    querySnapshot.docs.forEach((element) {
      clnName = element.id;
      docss.add(clnName);
    });
    for (int i = 0; i < docss.length; i++) {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(docss[i])
          .get()
          .then((value) {
        if (value.data()!['Employee Id'] == id) {
          setState(() {
            name = value.data()!['FirstName'];
            lastName = value.data()!['LastName'];
            mobileNum = value.data()!['Phone Number'];
          });
        }
      });
    }
  }

  // Future<void> nestedTableData(docss) async {
  //   for (int i = 0; i < docss.length; i++) {
  //     await FirebaseFirestore.instance
  //         .collection('User')
  //         .doc(widget.depoName!)
  //         .collection('KeyDataTable')
  //         .doc(docss[i])
  //         .collection('KeyAllEvents')
  //         .get()
  //         .then((value) {
  //       value.docs.forEach((element) {
  //         print('after');
  //         if (element.id == '${widget.depoName}A2') {
  //           for (int i = 0; i < element.data()['data'].length; i++) {
  //             _employees.add(Employee.fromJson(element.data()['data'][i]));
  //             print(_employees);
  //           }
  //         }
  //       });
  //     });
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
}
