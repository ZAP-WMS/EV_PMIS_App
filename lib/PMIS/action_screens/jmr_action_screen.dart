import 'package:ev_pmis_app/PMIS/user/screen/jmr.dart';
import 'package:flutter/material.dart';
import '../admin/screen/jmr.dart';

class JmrActionScreen extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String? userId;
  String roleCentre;

  JmrActionScreen(
      {super.key,
      required this.roleCentre, this.userId, this.cityName, this.role, this.depoName});

  @override
  State<JmrActionScreen> createState() => _JmrActionScreenState();
}

class _JmrActionScreenState extends State<JmrActionScreen> {
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
        selectedUi = JmrUserPage(
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: widget.depoName,
          role: widget.role,
        );
        break;

      case 'admin':
        selectedUi = Jmr(
          userId: widget.userId,
          role: widget.role!,
          depoName: widget.depoName,
          cityName: widget.cityName,
        );
        break;

      case 'projectManager':
        selectedUi = Jmr(
          userId: widget.userId,
          role: widget.role!,
          depoName: widget.depoName,
          cityName: widget.cityName,
        );
        break;
    }


    return selectedUi;
  }
}
