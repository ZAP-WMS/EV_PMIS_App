import 'package:ev_pmis_app/O_AND_M/user/dailyreport/daily_management.dart';
import 'package:ev_pmis_app/O_AND_M/user/dailyreport/daily_management_home.dart';
import 'package:ev_pmis_app/O_AND_M/user/management_screen/monthly_page/monthly_home.dart';
import 'package:flutter/material.dart';

import '../admin/daily_management_admin.dart';
import '../admin/monthly_management_admin.dart';
import '../admin/monthly_management_admin_home.dart';

class MonthlyManagementAction extends StatefulWidget {
  final String? role;
  final String? cityName;
  final String? depoName;
  final String userId;
  final String roleCentre;

  const MonthlyManagementAction(
      {super.key,
      this.cityName,
      this.role,
      this.depoName,
      required this.userId,
      required this.roleCentre});

  @override
  State<MonthlyManagementAction> createState() =>
      _MonthlyManagementActionState();
}

class _MonthlyManagementActionState extends State<MonthlyManagementAction> {
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
        selectedUi = MonthlyManagementHomePage(
          // tabIndex: 0,
          // tabletitle: 'Daily Progress Report',
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
          role: widget.role!,
        );
        break;

      case 'admin':
        selectedUi = MonthlyManagementAdminHomePage(
          // tabIndex: 0,
          // tabletitle: 'Monthly Report',
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
          role: widget.role!,
        );
        break;

      case "projectManager":
        selectedUi = MonthlyManagementAdminHomePage(
          // tabIndex: 0,
          // tabletitle: 'Monthly Report',
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
          role: widget.role!,
        );
        break;
    }

    return selectedUi;
  }
}
