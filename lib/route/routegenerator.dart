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
import '../views/dailyreport/daily_management_home.dart';
import '../views/dailyreport/notification_userlist.dart';
import '../views/management_screen/monthly_page/monthly_home.dart';
import '../views/overviewpage/overview.dart';
import '../views/split_screen/o&m_pmis_screen.dart';

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
            roleCentre: argument["roleCentre"],
            userId: argument['userId'],
            depoName: argument['depoName'],
            role: argument['role'],
          );
        case '/planning-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return ProjectPlanningAction(
             roleCentre: argument["roleCentre"],
            role: argument['role'], userId: argument["userId"],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            // role: argument['role'],
          );

        case '/material-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return MaterialProcurementAction(
             roleCentre: argument["roleCentre"],
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/daily-report':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DailyProjectAction(
             roleCentre: argument["roleCentre"],
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/monthly-report':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return MonthlyReportAction(
             roleCentre: argument["roleCentre"],
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/detailed-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DetailEngineeringAction(
             roleCentre: argument["roleCentre"],
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/jmrPage':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return JmrActionScreen(
             roleCentre: argument["roleCentre"],
            userId: argument['userId'],
            depoName: argument['depoName'],
            role: argument['role'],
            cityName: argument['cityName'],
          );

        case '/safety-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return SafetyChecklistAction(
             roleCentre: argument["roleCentre"],
            userId: argument['userId'],
            depoName: argument['depoName'],
            cityName: argument['cityName'],
            role: argument['role'],
          );

        case '/quality-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return QualityChecklistAction(
             roleCentre: argument["roleCentre"],
            userId: argument['userId'],
            depoName: argument['depoName'],
            role: argument['role'],
            cityName: argument['cityName'],
          );

        case '/closure-page':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return ClosureReportAction(
             roleCentre: argument["roleCentre"],
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
          return EVDashboardAction(roleCentre: args["roleCentre"],
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
            roleCentre: argument["roleCentre"],
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
        case '/main_screen':
        Map<String,dynamic> mapData = settings.arguments as Map<String,dynamic>;
          return PmisAndOAndMScreen(
            roleCentre: mapData["roleCentre"],
            userId : mapData["userId"],
            role : mapData["role"],
          );

        case '/daiy_management':
          // List<String> argument = [];
          // settings.arguments as Map<String, dynamic>;
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DailyManagementHomePage(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/monthly_management':
          // List<String> argument = [];
          // settings.arguments as Map<String, dynamic>;
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return MonthlyManagementHomePage(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );
      }
      return const NodataAvailable();
    });
  }
}
