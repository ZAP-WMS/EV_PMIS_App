import 'package:ev_pmis_app/screen/Detailedreport/detail_report_admin/detail_admin.dart';
import 'package:flutter/material.dart';
import '../Detailedreport/detailed_Eng.dart';

class DetailEngineeringAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String userId;
  String roleCentre;

  DetailEngineeringAction(
      {super.key,
      required this.roleCentre,
      required this.userId,
      this.cityName,
      this.role,
      this.depoName});

  @override
  State<DetailEngineeringAction> createState() =>
      _DetailEngineeringActionState();
}

class _DetailEngineeringActionState extends State<DetailEngineeringAction> {
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
    if(widget.roleCentre == "PMIS"){
          switch (widget.role) {
      case 'user':
        selectedUi = DetailedEng(
          depoName: widget.depoName,
          cityName: widget.cityName,
          userId: widget.userId,
          role: 'user',
        );

        break;
      case 'admin':
        selectedUi = DetailedEngAdmin(
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: 'admin',
        );

        break;
      case 'projectManager':
        selectedUi = DetailedEngAdmin(
          cityName: widget.cityName,
          userId: widget.userId,
          depoName: widget.depoName,
          role: widget.role,
        );
        break;
    }
    } else if(widget.roleCentre == "O&M"){
          switch (widget.role) {
      case 'user':
        selectedUi = DetailedEng(
          depoName: widget.depoName,
          cityName: widget.cityName,
          userId: widget.userId,
          role: 'user',
        );

        break;
      case 'admin':
        selectedUi = DetailedEngAdmin(
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: 'admin',
        );

        break;
      case 'projectManager':
        selectedUi = DetailedEngAdmin(
          cityName: widget.cityName,
          userId: widget.userId,
          depoName: widget.depoName,
          role: widget.role,
        );
        break;
    }
    }

    return selectedUi;
  }
}
