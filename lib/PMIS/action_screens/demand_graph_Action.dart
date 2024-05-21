import 'package:ev_pmis_app/PMIS/user/screen/energy_management.dart';
import 'package:ev_pmis_app/PMIS/admin/screen/energy_management_admin.dart.dart';
import 'package:flutter/material.dart';

class DemandActionScreen extends StatefulWidget {
  String role;
  String? cityName;
  String? depoName;
  String userId;
  String roleCentre;

  DemandActionScreen(
      {super.key,
      required this.roleCentre,
      this.cityName,
      required this.role,
      this.depoName,
      required this.userId});

  @override
  State<DemandActionScreen> createState() => _DemandActionScreenState();
}

class _DemandActionScreenState extends State<DemandActionScreen> {
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
        selectedUi = EnergyManagement(
          role: widget.role,
          depoName: widget.depoName,
          cityName: widget.cityName,
          userId: widget.userId,
        );
        break;
      case 'admin':
        selectedUi = EnergyManagementAdmin(
          userId: widget.userId,
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depoName,
        );
        break;

      case 'projectManager':
        selectedUi = EnergyManagementAdmin(
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
        );
        break;
    }


    return selectedUi;
  }
}
