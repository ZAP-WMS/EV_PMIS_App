import 'package:ev_pmis_app/screen/closureReport/closurefield.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/quality_checklist.dart';
import 'package:flutter/material.dart';

class ClosureReportAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;

  ClosureReportAction({super.key, this.cityName, this.role, this.depoName});

  @override
  State<ClosureReportAction> createState() => _ClosureReportActionState();
}

class _ClosureReportActionState extends State<ClosureReportAction> {
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
        selectedUi = ClosureField(depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = ClosureField(depoName: widget.depoName);
    }

    return selectedUi;
  }
}
