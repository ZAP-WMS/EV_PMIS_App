import 'package:ev_pmis_app/screen/materialprocurement/material_vendor_admin/material_vendor.dart';
import 'package:ev_pmis_app/views/materialprocurement/material_vendor.dart'
    as mv;
import 'package:flutter/material.dart';

class MaterialProcurementAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String userId;
  MaterialProcurementAction(
      {super.key,
      required this.userId,
      this.cityName,
      this.role,
      this.depoName});

  @override
  State<MaterialProcurementAction> createState() =>
      _MaterialProcurementActionState();
}

class _MaterialProcurementActionState extends State<MaterialProcurementAction> {
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
        selectedUi = mv.MaterialProcurement(
          depoName: widget.depoName,
          userId: widget.userId,
          cityName: widget.cityName,
          role: widget.role,
        );
        break;

      case 'admin':
        selectedUi = MaterialProcurementAdmin(
          cityName: widget.cityName,
          userId: widget.userId,
          depoName: widget.depoName,
          role: widget.role!,
        );
        break;

      case 'projectManager':
        selectedUi = MaterialProcurementAdmin(
          role: widget.role!,
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
        );
        break;
    }

    return selectedUi;
  }
}
