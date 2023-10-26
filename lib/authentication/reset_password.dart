import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/authentication/check_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class ResetPass extends StatefulWidget {
  // final String email;
  ResetPass({
    Key? key,
    // required this.email,
  }) : super(key: key);

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  FocusNode? _focusNode;
  TextEditingController textEditingController = TextEditingController();
  List docss = [];
  int? mobileNum;

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
                        getNumber(textEditingController.text).whenComplete(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckOtp(
                                        mobileNumber: mobileNum!.toInt(),
                                      )));
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('User Id is required'),
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
            mobileNum = value.data()!['Phone Number'];
            print(mobileNum);
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
