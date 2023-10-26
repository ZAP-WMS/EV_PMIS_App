import 'package:ev_pmis_app/screen/jmrPage/jmr_user/jmr.dart';
import 'package:flutter/material.dart';

import '../screen/jmrPage/jmr_admin/jmr.dart';

class JmrActionScreen extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  JmrActionScreen({super.key, this.cityName, this.role, this.depoName});

  @override
  State<JmrActionScreen> createState() => _JmrActionScreenState();
}

class _JmrActionScreenState extends State<JmrActionScreen> {
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
        selectedUi =
            JmrUserPage(cityName: widget.cityName, depoName: widget.depoName);
        break;
      case 'admin':
        selectedUi = Jmr(
          depoName: widget.depoName,
          cityName: widget.cityName,
        );
    }

    return selectedUi;
  }
}
