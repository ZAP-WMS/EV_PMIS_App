import 'package:ev_pmis_app/screen/planning/planning_admin/planning_summary.dart';
import 'package:ev_pmis_app/views/keyevents/key_events2.dart';
import 'package:flutter/material.dart';

class TestingAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String? userId;
  String roleCentre;

  TestingAction(
      {super.key,
      required this.roleCentre,
      this.cityName,
      this.role,
      this.depoName});

  @override
  State<TestingAction> createState() => _TestingActionState();
}

class _TestingActionState extends State<TestingAction> {
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
              cityName: widget.cityName,
              depoName: widget.depoName,
              role: widget.role!,
              userId: widget.userId);
          break;
        case 'admin':
          selectedUi = PlanningTable(
              role: widget.role!,
              userId: widget.userId,
              cityName: widget.cityName,
              depoName: widget.depoName);
          break;
        case 'projectManager':
          selectedUi = PlanningTable(
              userId: widget.userId,
              role: widget.role!,
              cityName: widget.cityName,
              depoName: widget.depoName);
          break;
      }

    return selectedUi;
  }
}
