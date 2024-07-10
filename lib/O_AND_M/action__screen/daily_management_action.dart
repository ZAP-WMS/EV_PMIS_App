import 'package:ev_pmis_app/O_AND_M/user/dailyreport/daily_management.dart';
import 'package:flutter/material.dart';

class DailyManagementAction extends StatefulWidget {
  final String? role;
  final String? cityName;
  final String? depoName;
  final String userId;
  final String roleCentre;

  const DailyManagementAction(
      {super.key,
      this.cityName,
      this.role,
      this.depoName,
      required this.userId,
      required this.roleCentre});

  @override
  State<DailyManagementAction> createState() =>
      _DailyManagementActionState();
}

class _DailyManagementActionState extends State<DailyManagementAction> {
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
        selectedUi = DailyManagementPage(
          tabIndex: 0,
          tabletitle: 'Daily Progress Report',
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
          role: widget.role!,
        );
        break;

      case 'admin':
        selectedUi = DailyManagementPage(
          tabIndex: 0,
          tabletitle: 'Daily Progress Report',
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: widget.role!,
        );
        break;

      case "projectManager":
        selectedUi = DailyManagementPage(
          tabIndex: 0,
          tabletitle: 'Daily Progress Report',
            userId: widget.userId,
            cityName: widget.cityName,
            depoName: widget.depoName,
            role: widget.role!
            );
        break;
    }

    return selectedUi;
  }

}
