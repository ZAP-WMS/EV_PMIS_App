import 'package:ev_pmis_app/screen/jmrPage/jmr.dart';
import 'package:ev_pmis_app/screen/planning/project_planning.dart';
import 'package:flutter/material.dart';
import '../screen/jmrPage/jmr_admin/jmr.dart';

class ProjectPlanningAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  ProjectPlanningAction({super.key, this.cityName, this.role, this.depoName});

  @override
  State<ProjectPlanningAction> createState() => _ProjectPlanningActionState();
}

class _ProjectPlanningActionState extends State<ProjectPlanningAction> {
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
        selectedUi =
            KeyEvents(cityName: widget.cityName, depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = KeyEvents(
          depoName: widget.depoName,
          cityName: widget.cityName,
        );
    }

    return selectedUi;
  }
}
