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
import 'package:ev_pmis_app/action_screens/testing_action.dart';
import 'package:ev_pmis_app/authentication/login_register.dart';
import 'package:ev_pmis_app/provider/internet_provider.dart';
import 'package:ev_pmis_app/screen/citiespage/cities_home.dart';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:ev_pmis_app/screen/homepage/home_page.dart';
import 'package:ev_pmis_app/screen/overviewpage/overview.dart';
import 'package:flutter/material.dart';
import '../action_screens/jmr_action_screen.dart';
import 'package:ev_pmis_app/widgets/no_internet.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    return MaterialPageRoute(builder: (context) {
      final isConnected =
          Provider.of<ConnectivityProvider>(context).isConnected;
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
          return HomePage();
        case '/cities-page':
          return CitiesHome();
        case '/overview page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return OverviewPage(
            depoName: argument['depoName'],
            role: argument['role'],
          );

//
// Overview Pages Start from here...
//

        case '/depotOverview':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DepotOverviewAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/planning-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return ProjectPlanningAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/material-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return MaterialProcurementAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/daily-report':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DailyProjectAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/monthly-report':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return MonthlyReportAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/detailed-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DetailEngineeringAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/jmrPage':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return JmrActionScreen(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/safety-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return SafetyChecklistAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/quality-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return QualityChecklistAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/testing-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return TestingAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/closure-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return ClosureReportAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );
      }
      return const NodataAvailable();
    });
  }
}
