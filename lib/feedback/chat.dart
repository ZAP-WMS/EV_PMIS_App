import 'package:flutter/material.dart';

import '../PMIS/widgets/custom_appbar.dart';
import '../PMIS/widgets/navbar.dart';

class ChatPage extends StatefulWidget {
  String depoName;
  ChatPage({super.key, required this.depoName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavbarDrawer(role: widget.role!),
      appBar: CustomAppBar(
          depoName: widget.depoName,
          title: 'Feedback Page',
          height: 50,
          isSync: false,
          isCentered: false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/keyevents/underconstruction5.jpeg'),
          const Text(
            'Feedback Page are \n Under Process',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
