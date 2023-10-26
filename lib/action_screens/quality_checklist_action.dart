import 'package:flutter/material.dart';

import '../screen/qualitychecklist/quality_admin/quality_home_admin.dart';
import '../screen/qualitychecklist/quality_home.dart';

class QualityChecklistAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;

  QualityChecklistAction({super.key, this.cityName, this.role, this.depoName});

  @override
  State<QualityChecklistAction> createState() => _QualityChecklistActionState();
}

class _QualityChecklistActionState extends State<QualityChecklistAction> {
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
        selectedUi = QualityHome(depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = QualityHomeAdmin(
            cityName: widget.cityName, depoName: widget.depoName);
    }

    return selectedUi;
  }
}
