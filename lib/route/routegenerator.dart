import 'package:ev_pmis_app/Splash/splash_screen.dart';
import 'package:ev_pmis_app/action_screens/closure_report_Action.dart';
import 'package:ev_pmis_app/action_screens/daily_progress_action.dart';
import 'package:ev_pmis_app/action_screens/depot_overview_action.dart';
import 'package:ev_pmis_app/action_screens/detail_eng_action.dart';
import 'package:ev_pmis_app/action_screens/material_procurement_action.dart';
import 'package:ev_pmis_app/action_screens/monthly_report_action.dart';
import 'package:ev_pmis_app/action_screens/project_planning_action.dart';
import 'package:ev_pmis_app/action_screens/quality_checklist_action.dart';
import 'package:ev_pmis_app/action_screens/safety_checklist_action.dart';
import 'package:ev_pmis_app/authentication/login_register.dart';
import 'package:ev_pmis_app/provider/internet_provider.dart';
import 'package:ev_pmis_app/screen/Detailedreport/detailed_Eng.dart';
import 'package:ev_pmis_app/screen/citiespage/cities_home.dart';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:ev_pmis_app/screen/homepage/home_page.dart';
import 'package:ev_pmis_app/screen/overviewpage/overview.dart';
import 'package:flutter/material.dart';
import '../action_screens/jmr_action_screen.dart';

import 'package:ev_pmis_app/screen/materialprocurement/material_vendor.dart';
import 'package:ev_pmis_app/screen/materialprocurement/upload_matrial.dart';
import 'package:ev_pmis_app/screen/monthlyreport/monthly_project.dart';
import 'package:ev_pmis_app/screen/overviewpage/depot_overview.dart';
import 'package:ev_pmis_app/screen/overviewpage/overview.dart';
import 'package:ev_pmis_app/screen/safetyreport/safetyfield.dart';
import 'package:ev_pmis_app/screen/testingpage/testing_page.dart';
import 'package:ev_pmis_app/widgets/no_internet.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../feedback/chat.dart';

import '../screen/closureReport/closurefield.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    return MaterialPageRoute(builder: (context) {
      final isConnected =
          Provider.of<ConnectivityProvider>(context).isConnected;
      print('status$isConnected');
      if (!isConnected) {
        return const NoInterneet();
      }
      switch (settings.name) {
        case '/splash-screen':
          return const SplashScreen();
        case '/login-page':
          return const LoginRegister();
        case '/gallery':
          return const GalleryPage();
        case '/homepage':
          return const HomePage();
        case '/cities-page':
          return const CitiesHome();
        case '/depotOverview':
          return DepotOverview(depoName: args.toString());
        case '/overview page':
          return OverviewPage(depoName: args.toString());
        // case '/overview-table':
        //   return MaterialPageRoute(
        //       builder: (context) => OverviewTable(depoName: args.toString()));
        case '/planning-page':
          return KeyEvents(depoName: args.toString());
        case '/material-page':
          return MaterialProcurement(depoName: args.toString());

  }
}
