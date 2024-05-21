import 'package:ev_pmis_app/PMIS/admin/screen/planning_summary.dart';
import 'package:ev_pmis_app/PMIS/user/keyevents/key_events2.dart';
import 'package:flutter/material.dart';

class EasyMonitoringAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String? userId;
  String roleCentre;

  EasyMonitoringAction({super.key,
  required this.roleCentre, this.cityName, this.role, this.depoName});

  @override
  State<EasyMonitoringAction> createState() => _EasyMonitoringActionState();
}

class _EasyMonitoringActionState extends State<EasyMonitoringAction> {
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
        selectedUi = KeyEvents2(
          role: widget.role!,
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
        );
        break;
      case 'admin':
        selectedUi = PlanningTable(
          role: widget.role!,
          depoName: widget.depoName,
        );
        break;
      case 'projectManager':
        selectedUi = PlanningTable(
          role: widget.role!,
          depoName: widget.depoName,
        );
        break;
    }
    


    return selectedUi;
  }
}
