import 'package:ev_pmis_app/screen/dailyreport/daily_report_admin/daily_report_admin.dart';
import 'package:ev_pmis_app/views/dailyreport/daily_management_home.dart';
import 'package:flutter/material.dart';

import '../dailyreport/daily_project.dart';

class DailyProjectAction extends StatefulWidget {
  final String role;
  final String? cityName;




  
  final String? depoName;
  final String userId;
  final String roleCentre;

  const DailyProjectAction(
      {super.key,
      required this.roleCentre,
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return selectedUi;
  }

  Widget selectWidget() {
    if (widget.roleCentre == "PMIS") {
      switch (widget.role) {
        
        case 'user':
          selectedUi = DailyProject(
            cityName: widget.cityName,
            userId: widget.userId,
            role: widget.role,
            depoName: widget.depoName,
          );
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
    } else if (widget.roleCentre == "O&M") {
      switch (widget.role) {
        case 'user':
          selectedUi = DailyManagementHomePage(
            cityName: widget.cityName,
            userId: widget.userId,
            role: widget.role,
            depoName: widget.depoName,
          );
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
    }

    return selectedUi;
  }
}
