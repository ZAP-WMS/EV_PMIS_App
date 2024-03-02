import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_appbar.dart';

class userList extends StatefulWidget {
  const userList({super.key});

  @override
  State<userList> createState() => _userListState();
}

class _userListState extends State<userList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: blue,
      title: Text(
        'UserList',
        style: TextStyle(fontSize: 15, color: white),
      ),
    )
        //  CustomAppBar(
        //   depoName: '',
        //   isCentered: true,
        //   title: 'userList',
        //   height: 50,
        //   isSync: false,
        // ),
        );
  }
}
