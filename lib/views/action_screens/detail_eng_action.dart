import 'package:flutter/material.dart';

import '../Detailedreport/detailed_Eng.dart';

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
