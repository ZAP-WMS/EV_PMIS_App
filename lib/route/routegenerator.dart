import 'package:ev_pmis_app/views/Splash/splash_screen.dart';
import 'package:ev_pmis_app/views/action_screens/closure_report_Action.dart';
import 'package:ev_pmis_app/views/action_screens/daily_progress_action.dart';
import 'package:ev_pmis_app/views/action_screens/demand_graph_Action.dart';
import 'package:ev_pmis_app/views/action_screens/depot_overview_action.dart';
import 'package:ev_pmis_app/views/action_screens/detail_eng_action.dart';
import 'package:ev_pmis_app/views/action_screens/ev_dashboard_action.dart';
import 'package:ev_pmis_app/views/action_screens/material_procurement_action.dart';
import 'package:ev_pmis_app/views/action_screens/monthly_report_action.dart';
import 'package:ev_pmis_app/views/action_screens/project_planning_action.dart';
import 'package:ev_pmis_app/views/action_screens/quality_checklist_action.dart';
import 'package:ev_pmis_app/views/action_screens/safety_checklist_action.dart';
import 'package:ev_pmis_app/views/authentication/login_register.dart';
import 'package:ev_pmis_app/provider/internet_provider.dart';
import 'package:ev_pmis_app/screen/demand_energy/demandScreen.dart';
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
          final args = settings.arguments as Map<String, dynamic>;
          return CitiesHome(
            userId: args["userId"],
            role: args['role'],
          );

        case '/depot-inside-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;

          return UploadDocument(
            title: 'Depot Insights',
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            userId: userId,
            fldrName: 'DepotImages',
          );

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
            userId: argument['userId'],
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/planning-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return ProjectPlanningAction(
            role: argument['role'], userId: argument["userId"],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            // role: argument['role'],
          );

        case '/material-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return MaterialProcurementAction(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/daily-report':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DailyProjectAction(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/monthly-report':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return MonthlyReportAction(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/detailed-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DetailEngineeringAction(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/jmrPage':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return JmrActionScreen(
            userId: argument['userId'],
            depoName: argument['depoName'],
            role: argument['role'],
            cityName: argument['cityName'],
          );

        case '/safety-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return SafetyChecklistAction(
            userId: argument['userId'],
            depoName: argument['depoName'],
            cityName: argument['cityName'],
            role: argument['role'],
          );

        case '/quality-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return QualityChecklistAction(
            userId: argument['userId'],
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
            userId: argument['userId'],
            role: argument['role'],
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
          final args = settings.arguments as Map<String, dynamic>;
          final userId = args["userId"];
          final role = args["role"];
          return EVDashboardAction(
            role: role,
          );

        case '/demand':
          return DemandEnergyScreen();

        case '/splitDashboard':
          final args = settings.arguments as Map<String, dynamic>;
          return SplitScreen(
            role: args["role"],
            userId: args["userId"],
          );

        case '/depot-energy':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DemandActionScreen(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        // case '/split-screen':
        //   Map<String, dynamic> argument =
        //       settings.arguments as Map<String, dynamic>;
        //   return SplitScreen(role: '');
        // DemandActionScreen(
        //   cityName: argument['cityName'],
        //   depoName: argument['depoName'],
        //   role: argument['role'],
        // );

        case '/user-list':
          // List<String> argument = [];
          // settings.arguments as Map<String, dynamic>;
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
