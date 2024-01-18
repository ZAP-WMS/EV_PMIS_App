import 'package:ev_pmis_app/views/Splash/splash_screen.dart';
import 'package:ev_pmis_app/views/action_screens/closure_report_Action.dart';
import 'package:ev_pmis_app/views/action_screens/daily_progress_action.dart';
import 'package:ev_pmis_app/views/action_screens/depot_overview_action.dart';
import 'package:ev_pmis_app/views/action_screens/detail_eng_action.dart';
import 'package:ev_pmis_app/views/action_screens/material_procurement_action.dart';
import 'package:ev_pmis_app/views/action_screens/monthly_report_action.dart';
import 'package:ev_pmis_app/views/action_screens/quality_checklist_action.dart';
import 'package:ev_pmis_app/views/action_screens/safety_checklist_action.dart';
import 'package:ev_pmis_app/views/authentication/login_register.dart';
import 'package:ev_pmis_app/provider/internet_provider.dart';
import 'package:ev_pmis_app/views/energy_management/energy_management.dart';
import 'package:ev_pmis_app/widgets/upload.dart';
import 'package:flutter/material.dart';
import '../views/action_screens/jmr_action_screen.dart';
import 'package:ev_pmis_app/widgets/no_internet.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';
import 'package:provider/provider.dart';
import '../views/authentication/change_password.dart';
import '../views/chatPage/feedback.dart';
import '../views/citiespage/cities_home.dart';
import '../views/homepage/gallery.dart';
import '../views/homepage/home_page.dart';
import '../views/keyevents/key_events2.dart';
import '../views/overviewpage/overview.dart';
import '../views/testingpage/testing_page.dart';

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
        case '/depot-inside-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return UploadDocument(
              pagetitle: 'Overview Page',
              cityName: argument['cityName'],
              depoName: argument['depoName'],
              userId: userId,
              fldrName: 'OverviewepoImages');
        case '/chat-page':
          return FeedbackPage();
        case '/overview page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return OverviewPage(
              depoName: argument['depoName'], role: argument['role']);

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
          return KeyEvents2(
            depoName: argument['depoName'],
            // role: argument['role'],
          );
        // case '/planning-page':
        //   Map<String, dynamic> argument =
        //       settings.arguments as Map<String, dynamic>;
        //   return ProjectPlanningAction(
        //     depoName: argument['depoName'],
        //     role: argument['role'],
        //   );

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
            cityName: argument['cityName'],
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
            cityName: argument['cityName'],
            role: argument['role'],
          );

        case '/quality-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return QualityChecklistAction(
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/closure-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return ClosureReportAction(
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/change-password':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return ChangePassword(
            name: argument['name'],
            mobileNumber: argument[' mobileNumber'],
          );

        case '/depot-energy':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return EnergyManagement(
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            userId: userId,
          );
      }
      return const NodataAvailable();
    });
  }
}
