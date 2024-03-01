import 'package:ev_pmis_app/views/Splash/splash_screen.dart';
import 'package:ev_pmis_app/views/action_screens/closure_report_Action.dart';
import 'package:ev_pmis_app/views/action_screens/daily_progress_action.dart';
import 'package:ev_pmis_app/views/action_screens/demand_graph_Action.dart';
import 'package:ev_pmis_app/views/action_screens/depot_overview_action.dart';
import 'package:ev_pmis_app/views/action_screens/detail_eng_action.dart';
import 'package:ev_pmis_app/views/action_screens/ev_dashboard_action.dart';
import 'package:ev_pmis_app/views/action_screens/material_procurement_action.dart';
import 'package:ev_pmis_app/views/action_screens/monthly_report_action.dart';
import 'package:ev_pmis_app/views/action_screens/quality_checklist_action.dart';
import 'package:ev_pmis_app/views/action_screens/safety_checklist_action.dart';
import 'package:ev_pmis_app/views/authentication/login_register.dart';
import 'package:ev_pmis_app/provider/internet_provider.dart';
import 'package:ev_pmis_app/screen/demand_energy/demandScreen.dart';
import 'package:ev_pmis_app/screen/ev_dashboard/ev_dashboard_user/ev_dashboard_user.dart';
import 'package:ev_pmis_app/screen/otp_verification/send_otp.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/quality_admin/quality_home_admin.dart';
import 'package:ev_pmis_app/screen/split_dashboard/split_screen.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';

import 'package:ev_pmis_app/widgets/upload.dart';
import 'package:flutter/material.dart';
import '../views/action_screens/jmr_action_screen.dart';
import 'package:ev_pmis_app/widgets/no_internet.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';
import 'package:provider/provider.dart';
import '../views/authentication/change_password.dart';
import '../views/chatPage/feedback.dart';
import '../views/citiespage/cities_home.dart';
import '../views/dailyreport/notification_userlist.dart';
import '../views/keyevents/key_events2.dart';
import '../views/overviewpage/overview.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      final isConnected =
          Provider.of<ConnectivityProvider>(context).isConnected;
      if (!isConnected) {
        return const NoInterneet();
      }
      switch (settings.name) {
        case '/verifyPage':
          return const OtpVerificationScreen();
        case '/splash-screen':
          return const SplashScreen();
        case '/login-page':
          return const LoginRegister();
        case '/cities-page':
          return CitiesHome();
        case '/depot-inside-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return UploadDocument(
              pagetitle: 'Depot Insights',
              cityName: argument['cityName'],
              depoName: argument['depoName'],
              userId: userId,
              fldrName: 'DepotImages');
        case '/chat-page':
          return FeedbackPage();
        case '/overview page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return OverviewPage(
            depoName: argument['depoName'],
            role: argument['role'],
            userId: argument['userId'],
          );

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

        case '/material-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return MaterialProcurementAction(
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/daily-report':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DailyProjectAction(
            cityName: argument['cityName'],
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
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/jmrPage':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return JmrActionScreen(
            depoName: argument['depoName'],
            role: argument['role'],
            cityName: argument['cityName'],
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
            cityName: argument['cityName'],
          );

        case '/closure-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return ClosureReportAction(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/quality-admin':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return QualityHomeAdmin(
            cityName: argument['cityName'],
            depoName: argument['depoName'],
          );
        case '/change-password':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return ChangePassword(
            name: argument['name'],
            mobileNumber: argument[' mobileNumber'],
          );
        case '/evDashboard':
          final role = settings.arguments as String;
          // CustomPageRoute(page: page)
          return EVDashboardAction(
            role: role,
          );

        case '/demand':
          return DemandEnergyScreen();

        case '/splitDashboard':
          final args = settings.arguments as String;
          return SplitScreen(
            role: args,
          );

        case '/depot-energy':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DemandActionScreen(
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/user-list':
          // Map<String, dynamic> argument =
          //     settings.arguments as Map<String, dynamic>;
          return userList();
        //  DemandActionScreen(
        //   cityName: argument['cityName'],
        //   depoName: argument['depoName'],
        //   role: argument['role'],
        // );
      }
      return const NodataAvailable();
    });
  }
}
