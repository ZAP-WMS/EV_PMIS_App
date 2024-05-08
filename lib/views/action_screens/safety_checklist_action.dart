import 'package:flutter/material.dart';
import '../safetyreport/safety_report_admin.dart/safety_report_admin.dart';
import '../safetyreport/safetyfield.dart';

class SafetyChecklistAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String userId;
  String roleCentre;

  SafetyChecklistAction({
    super.key,
    required this.roleCentre,
     this.cityName,
      this.role,
       this.depoName,
       required this.userId});

  @override
  State<SafetyChecklistAction> createState() => _SafetyChecklistActionState();

}

class _SafetyChecklistActionState extends State<SafetyChecklistAction> {
  Widget selectedUi = Container();

  @override
  void initState() {
    selectWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return selectedUi;
  }

  Widget selectWidget() {
          switch (widget.role) {
      case 'user':
        selectedUi = SafetyField(
          depoName: widget.depoName,
        role: widget.role,
        userId: widget.userId,
        cityName: widget.cityName,
        );
        break;
      case 'admin':
        selectedUi = SafetySummary(
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: widget.role!,
          userId: widget.userId,
        );
        break;
      case 'projectManager':
        selectedUi = SafetySummary(
          role: widget.role!,
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
        );
        break; 
    }


    return selectedUi;
  }
}
