
import 'package:flutter/material.dart';

import '../qualitychecklist/quality_home.dart';


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
        selectedUi = QualityHome(depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = QualityHome(depoName: widget.depoName);
    }

    return selectedUi;
  }
}
