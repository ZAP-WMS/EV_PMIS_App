import 'package:ev_pmis_app/views/overviewpage/overview_oAndM.dart';
import 'package:ev_pmis_app/views/overviewpage/overview_pmis.dart';
import 'package:flutter/material.dart';

class OverviewAction extends StatefulWidget {
  final String? role;
  final String? cityName;
  final String? depoName;
  final String userId;
  final String roleCentre;

  const OverviewAction(
      {super.key,
      this.cityName,
      this.role,
      this.depoName,
      required this.userId,
      required this.roleCentre});

  @override
  State<OverviewAction> createState() => _OverviewActionState();
}

class _OverviewActionState extends State<OverviewAction> {
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
      case 'PMIS':
        selectedUi = OverviewPmis(
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
          role: widget.role,
        );
        break;

      case 'O&M':
        selectedUi = OverviewOandM(
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: widget.role!,
        );
        break;
    }
    return selectedUi;
  }
}
