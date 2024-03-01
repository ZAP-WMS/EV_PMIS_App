import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'detailed_Eng.dart';

class DetailedEngHome extends StatefulWidget {
  String? depoName;
  String role;
  DetailedEngHome({super.key, required this.depoName, required this.role});

  @override
  State<DetailedEngHome> createState() => _DetailedEngHomeState();
}

class _DetailedEngHomeState extends State<DetailedEngHome> {
  List<String> title = [
    'RFC Drawing of Civil Activities',
    'EV Layout Drawing of Electrical Activities',
    'Shed Lighting Drawing & Specification'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          depoName: widget.depoName ?? '',
          isCentered: false,
          title: 'Detailed Engineering',
          height: 55,
          isSync: false),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedEng(
                      depoName: widget.depoName,
                      role: '',
                    ),
                  )),
              child: card(
                title[index],
              ));
        },
      ),
    );
  }

  Widget card(String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: blue,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: white)),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: white, fontSize: 20),
        ),
      ),
    );
  }
}
