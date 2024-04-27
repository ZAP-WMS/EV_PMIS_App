import 'package:ev_pmis_app/widgets/upload.dart';
import 'package:flutter/material.dart';

class DepotInsightsAction extends StatefulWidget {
  final String role;
  final String? cityName;
  final String? depoName;
  final String userId;
  final String roleCentre;

  const DepotInsightsAction(
      {super.key,
      required this.roleCentre,
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
    if(widget.roleCentre == "PMIS"){
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
    }
    else if(widget.roleCentre == "O&M"){
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
    }


    return selectedUi;
  }
}
