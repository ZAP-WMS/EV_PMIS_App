import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({
    super.key,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            depoName: '',
            title: 'Feedback Page',
            height: 50,
            isSync: false,
            isCentered: false),
        body: Center(
          child: Column(
            children: [
              Image.asset('assets/keyevents/underconstruction5.jpeg'),
              const Text(
                'Testing & Commissioning flow \n Under Process',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ));
  }
}
