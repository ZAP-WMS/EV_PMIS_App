import 'package:ev_pmis_app/PMIS/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  final String? depoName;
  const TestingPage({super.key, required this.depoName});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavbarDrawer(role: widget.role!),
      appBar: CustomAppBar(
          depoName: widget.depoName ?? '',
          title: 'Testing planning',
          height: 50,
          isSync: false,
          isCentered: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/keyevents/underconstruction5.jpeg',
          ),
          const Text(
            'Testing & Commissioning flow \n Under Process',
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
