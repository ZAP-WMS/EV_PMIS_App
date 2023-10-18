import 'package:ev_pmis_app/screen/materialprocurement/material_vendor.dart';
import 'package:flutter/material.dart';

class MaterialProcurementAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  MaterialProcurementAction(
      {super.key, this.cityName, this.role, this.depoName});

  @override
  State<MaterialProcurementAction> createState() =>
      _MaterialProcurementActionState();
}

class _MaterialProcurementActionState extends State<MaterialProcurementAction> {
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
        selectedUi = MaterialProcurement(depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = MaterialProcurement(
          depoName: widget.depoName,
        );
    }

    return selectedUi;
  }
}
