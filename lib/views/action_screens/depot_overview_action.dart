import 'package:ev_pmis_app/screen/overviewpage/depot_overview.dart';
import 'package:flutter/material.dart';

class DepotOverviewAction extends StatefulWidget {
  String role;
  String? cityName;
  String? depoName;
  String? userId;
  String roleCentre;

  DepotOverviewAction(
      {super.key,
      required this.roleCentre,
      this.cityName,
      required this.role,
      this.depoName,
      this.userId});

  @override
  State<DepotOverviewAction> createState() => _DepotOverviewActionState();
}

class _DepotOverviewActionState extends State<DepotOverviewAction> {
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
        selectedUi = DepotOverview(
          depoName: widget.depoName,
          userId: widget.userId,
          role: widget.role,
          cityName: widget.cityName,
        );
        break;
      case 'admin':
        selectedUi = DepotOverview(
          role: widget.role,
          userId: widget.userId,
          depoName: widget.depoName,
          cityName: widget.cityName,
        );
        break;
      case 'projectManager':
        selectedUi = DepotOverview(
          role: widget.role,
          userId: widget.userId,
          depoName: widget.depoName,
          cityName: widget.cityName,
        );
        break;
    }


    return selectedUi;
  }
}
