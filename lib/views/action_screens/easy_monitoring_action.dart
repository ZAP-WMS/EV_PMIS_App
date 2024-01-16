import 'package:flutter/material.dart';
import '../planning/project_planning.dart';

class EasyMonitoringAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;

  EasyMonitoringAction({super.key, this.cityName, this.role, this.depoName});

  @override
  State<EasyMonitoringAction> createState() => _EasyMonitoringActionState();
}

class _EasyMonitoringActionState extends State<EasyMonitoringAction> {
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
        selectedUi = KeyEvents(depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = KeyEvents(depoName: widget.depoName);
    }

    return selectedUi;
  }
}
