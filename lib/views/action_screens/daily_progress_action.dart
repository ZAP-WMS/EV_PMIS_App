import 'package:ev_pmis_app/screen/dailyreport/daily_report_admin/daily_report_admin.dart';
import 'package:flutter/material.dart';

import '../dailyreport/daily_project.dart';

class DailyProjectAction extends StatefulWidget {
  String role;
  String? cityName;
  String? depoName;
  String userId;
  DailyProjectAction(
      {super.key,
      this.cityName,
      required this.role,
      this.depoName,
      required this.userId});

  @override
  State<DailyProjectAction> createState() => _DailyProjectActionState();
}

class _DailyProjectActionState extends State<DailyProjectAction> {
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
        selectedUi = DailyProject(
            cityName: widget.cityName,
            userId: widget.userId,
            role: widget.role,
            depoName: widget.depoName);
        break;

      case 'admin':
        selectedUi = DailyProjectAdmin(
          role: widget.role,
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
        );
        break;

      case 'projectManager':
        selectedUi = DailyProjectAdmin(
          role: widget.role,
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
        );
        break;
    }

    return selectedUi;
  }
}
