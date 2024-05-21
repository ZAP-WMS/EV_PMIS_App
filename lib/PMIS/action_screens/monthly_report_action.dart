import 'package:flutter/material.dart';

import '../admin/screen/monthly_report_admin.dart';
import '../user/screen/monthly_project.dart';

class MonthlyReportAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String userId;
  String roleCentre;

  MonthlyReportAction({super.key,
  required this.roleCentre, this.cityName, this.role, this.depoName, required this.userId});

  @override
  State<MonthlyReportAction> createState() => _MonthlyReportActionState();
}

class _MonthlyReportActionState extends State<MonthlyReportAction> {
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
        selectedUi = MonthlyProject(
          depoName: widget.depoName,
        role: widget.role,cityName: widget.cityName,
        userId: widget.userId,);
        break;

      case 'admin':
        selectedUi = MonthlySummary(
          cityName: widget.cityName,
          depoName: widget.depoName,

          role: widget.role!,
          userId: widget.userId,
        );
        break;

      case 'projectManager':
        selectedUi = MonthlySummary(
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: widget.role!,
          userId: widget.userId,
        );
        break;
    }
    


    return selectedUi;
  }
}
