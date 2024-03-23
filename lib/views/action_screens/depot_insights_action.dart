import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/views/energy_management/energy_management.dart';
import 'package:ev_pmis_app/views/energy_management/energy_management_admin.dart.dart';
import 'package:ev_pmis_app/widgets/upload.dart';
import 'package:flutter/material.dart';

class DepotInsightsAction extends StatefulWidget {
  String role;
  String? cityName;
  String? depoName;
  String userId;

  DepotInsightsAction(
      {super.key,
      this.cityName,
      required this.role,
      this.depoName,
      required this.userId});

  @override
  State<DepotInsightsAction> createState() => _DepotInsightsActionState();
}

class _DepotInsightsActionState extends State<DepotInsightsAction> {
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
        selectedUi = UploadDocument(
          role: widget.role,
          fldrName: '',
          depoName: widget.depoName,
          cityName: widget.cityName,
          userId: widget.userId,
        );
        break;

      case 'admin':
        selectedUi = UploadDocument(
          userId: widget.userId,
          role: widget.role,
          cityName: widget.cityName,
          depoName: widget.depoName,
          fldrName: '',
        );
        break;

      case 'projectManager':
        selectedUi = UploadDocument(
          fldrName: '',
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
