import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/views/energy_management/energy_management.dart';
import 'package:ev_pmis_app/views/energy_management/energy_management_admin.dart.dart';
import 'package:flutter/material.dart';

class DemandActionScreen extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;

  DemandActionScreen({super.key, this.cityName, this.role, this.depoName});

  @override
  State<DemandActionScreen> createState() => _DemandActionScreenState();
}

class _DemandActionScreenState extends State<DemandActionScreen> {
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
        selectedUi = EnergyManagement(
          depoName: widget.depoName,
          cityName: widget.cityName,
          userId: userId,
        );
        break;
      case 'admin':
        selectedUi = EnergyManagementAdmin(
          cityName: widget.cityName,
          depoName: widget.depoName,
        );
    }

    return selectedUi;
  }
}
