import 'package:ev_pmis_app/screen/Detailedreport/detailed_Eng.dart';
import 'package:ev_pmis_app/screen/monthlyreport/monthly_project.dart';
import 'package:flutter/material.dart';

class DetailEngineeringAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;

  DetailEngineeringAction({super.key, this.cityName, this.role, this.depoName});

  @override
  State<DetailEngineeringAction> createState() =>
      _DetailEngineeringActionState();
}

class _DetailEngineeringActionState extends State<DetailEngineeringAction> {
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
        selectedUi = DetailedEng(depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = DetailedEng(
          depoName: widget.depoName,
        );
    }

    return selectedUi;
  }
}
