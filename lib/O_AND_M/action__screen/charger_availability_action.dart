import 'package:ev_pmis_app/O_AND_M/user/management_screen/charger_availabity_screen.dart';
import 'package:flutter/material.dart';

class ChargerAvailabilityAction extends StatefulWidget {

  final String? role;
  final String? cityName;
  final String? depoName;
  final String userId;
  final String roleCentre;

  const ChargerAvailabilityAction(
      {super.key,
      this.cityName,
      this.role,
      this.depoName,
      required this.userId,
      required this.roleCentre});

  @override
  State<ChargerAvailabilityAction> createState() =>
      _ChargerAvailabilityActionState();

}

class _ChargerAvailabilityActionState extends State<ChargerAvailabilityAction> {
  Widget selectedUi = Container();

  @override
  void initState() {
    print("roleInCharger - ${widget.role}");
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
        selectedUi = ChargerAvailabilityScreen(
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: widget.userId,
          role: widget.role,
        );
        break;

      case 'admin':
        selectedUi = ChargerAvailabilityScreen(
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: widget.role!,
        );
        break;

      case "projectManager":
        selectedUi = ChargerAvailabilityScreen(
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
