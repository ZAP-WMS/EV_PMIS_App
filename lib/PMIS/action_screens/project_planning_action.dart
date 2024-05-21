import 'package:ev_pmis_app/PMIS/admin/screen/planning_summary.dart';
import 'package:ev_pmis_app/PMIS/user/keyevents/key_events2.dart';
import 'package:flutter/material.dart';

class ProjectPlanningAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String userId;
  String roleCentre;

  ProjectPlanningAction(
      {super.key,
      required this.roleCentre,
      this.cityName,
      this.role,
      this.depoName,
      required this.userId});

  @override
  State<ProjectPlanningAction> createState() => _ProjectPlanningActionState();
}

class _ProjectPlanningActionState extends State<ProjectPlanningAction> {
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
          depoName: widget.depoName,
          cityName: widget.cityName,
          role: widget.role!,
          userId: widget.userId,
        );
        break;
      case 'projectManager':
        selectedUi = PlanningTable(
          userId: widget.userId,
          depoName: widget.depoName,
          cityName: widget.cityName,
          role: widget.role!,
        );
        break;
    }

    return selectedUi;
  }
}
