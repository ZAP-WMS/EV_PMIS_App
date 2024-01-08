import 'package:flutter/material.dart';

import '../monthlyreport/monthly_admin/monthly_report_admin.dart';
import '../monthlyreport/monthly_project.dart';


class MonthlyReportAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  MonthlyReportAction({super.key, this.cityName, this.role, this.depoName});

  @override
  State<MonthlyReportAction> createState() => _MonthlyReportActionState();
}

class _MonthlyReportActionState extends State<MonthlyReportAction> {
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
        selectedUi = MonthlyProject(depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = MonthlySummary(
          cityName: widget.cityName,
          depoName: widget.depoName,
        );
    }

    return selectedUi;
  }
}
