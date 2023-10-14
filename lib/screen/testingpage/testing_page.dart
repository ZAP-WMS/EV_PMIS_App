import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  String depoName;
  TestingPage({super.key, required this.depoName});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(),
      appBar: CustomAppBar(
          title: '${widget.depoName}/testing planning',
          height: 50,
          isSync: false,
          isCentered: true),
      body: const Center(
        child: Text(
          'Testing & Commissioning flow \n Under Process',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
