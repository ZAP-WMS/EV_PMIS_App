import 'package:ev_pmis_app/PMIS/user/screen/closurefield.dart';
import 'package:ev_pmis_app/PMIS/admin/screen/closure_summary_table.dart';
import 'package:flutter/material.dart';

class ClosureReportAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String userId;
  String roleCentre;

  ClosureReportAction(
      {super.key,
      this.cityName,
      this.role,
      this.depoName,
      required this.userId,
      required this.roleCentre});

  @override
  State<ClosureReportAction> createState() => _ClosureReportActionState();
}

class _ClosureReportActionState extends State<ClosureReportAction> {
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
        selectedUi = ClosureField(
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
          role: widget.role,
        );
        break;

      case 'admin':
        selectedUi = ClosureSummaryTable(
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: widget.role!,
        );
        break;

      case "projectManager":
        selectedUi = ClosureSummaryTable(
            userId: widget.userId,
            cityName: widget.cityName,
            depoName: widget.depoName,
            role: widget.role!);
        break;
    }
    


    return selectedUi;
  }
}
