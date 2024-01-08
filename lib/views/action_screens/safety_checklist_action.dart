
import 'package:flutter/material.dart';

import '../safetyreport/safety_report_admin.dart/safety_report_admin.dart';
import '../safetyreport/safetyfield.dart';

class SafetyChecklistAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;

  SafetyChecklistAction({super.key, this.cityName, this.role, this.depoName});

  @override
  State<SafetyChecklistAction> createState() => _SafetyChecklistActionState();
}

class _SafetyChecklistActionState extends State<SafetyChecklistAction> {
  Widget selectedUi = Container();

  @override
  void initState() {
    selectWidget();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return selectedUi;
  }

  Widget selectWidget() {
    switch (widget.role) {
      case 'user':
        selectedUi = SafetyField(depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = SafetySummary(
          cityName: widget.cityName,
          depoName: widget.depoName,
        );
    }

    return selectedUi;
  }
}
