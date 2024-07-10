import 'package:ev_pmis_app/PMIS/common_screen/ev_dashboard/ev_dashboard_admin/ev_dashboard_admin.dart';
import 'package:ev_pmis_app/PMIS/common_screen/ev_dashboard/ev_dashboard_user/ev_dashboard_user.dart';
import 'package:flutter/material.dart';

class EVDashboardAction extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String? userId;
  String roleCentre;

  EVDashboardAction(
      {super.key,
      required this.roleCentre, this.cityName, this.role, this.userId, this.depoName});

  @override
  State<EVDashboardAction> createState() => _EVDashboardActionState();
}

class _EVDashboardActionState extends State<EVDashboardAction> {
  Widget selectedUi = Container();

  @override
  void initState() {
    print('Role from evDashboard - ${widget.role}');
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
        selectedUi = EVDashboardUser(
          userId: widget.userId,
        );
        break;
      case 'admin':
        selectedUi = EVDashboardAdmin(
          role: widget.role!,
        );
        break;
      case 'projectManager':
        selectedUi = EVDashboardAdmin(
          role: widget.role!,
        );
        break;
    }

    return selectedUi;
  }
}
