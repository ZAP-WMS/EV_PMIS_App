
import 'package:flutter/material.dart';

import '../dailyreport/daily_project.dart';

class DailyProjectAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  DailyProjectAction({super.key, this.cityName, this.role, this.depoName});

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
        selectedUi = DailyProject(depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = DailyProject(
          depoName: widget.depoName,
        );
    }

    return selectedUi;
  }
}
