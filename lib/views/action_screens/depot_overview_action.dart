import 'package:ev_pmis_app/screen/overviewpage/depot_overview.dart';
import 'package:flutter/material.dart';

class DepotOverviewAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  DepotOverviewAction({super.key, this.cityName, this.role, this.depoName});

  @override
  State<DepotOverviewAction> createState() => _DepotOverviewActionState();
}

class _DepotOverviewActionState extends State<DepotOverviewAction> {
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
        selectedUi = DepotOverview(
          depoName: widget.depoName,
          role: widget.role,
        );
        break;
      case 'admin':
        selectedUi = DepotOverview(
          role: widget.role,
          depoName: widget.depoName,
        );
    }

    return selectedUi;
  }
}
