import 'package:ev_pmis_app/O_AND_M/user/management_screen/breakdown_screen.dart';
import 'package:flutter/material.dart';

class BreakdownAction extends StatefulWidget {
  final String? role;
  final String? cityName;
  final String? depoName;
  final String userId;
  final String roleCentre;

  const BreakdownAction(
      {super.key,
      this.cityName,
      this.role,
      this.depoName,
      required this.userId,
      required this.roleCentre});

  @override
  State<BreakdownAction> createState() =>
      _BreakdownActionState();
}

class _BreakdownActionState extends State<BreakdownAction> {
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
        selectedUi = BreakdownScreen(
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
          role: widget.role,
        );
        break;

      case 'admin':
        selectedUi = BreakdownScreen(
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: widget.role!,
        );
        break;

      case "projectManager":
        selectedUi = BreakdownScreen(
            userId: widget.userId,
            cityName: widget.cityName,
            depoName: widget.depoName,
            role: widget.role!
            );
        break;
    }

    return selectedUi;
  }

}
