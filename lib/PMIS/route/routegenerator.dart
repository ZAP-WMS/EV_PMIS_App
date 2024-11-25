import 'package:ev_pmis_app/O_AND_M/action__screen/breakdown_action.dart';
import 'package:ev_pmis_app/O_AND_M/action__screen/charger_availability_action.dart';
import 'package:ev_pmis_app/O_AND_M/action__screen/daily_management_action.dart';
import 'package:ev_pmis_app/O_AND_M/user/management_screen/oAndM_dashboard.dart';
import 'package:ev_pmis_app/PMIS/common_screen/Splash/splash_screen.dart';
import 'package:ev_pmis_app/PMIS/action_screens/closure_report_Action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/daily_progress_action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/demand_graph_Action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/depot_overview_action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/detail_eng_action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/ev_dashboard_action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/material_procurement_action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/monthly_report_action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/project_planning_action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/quality_checklist_action.dart';
import 'package:ev_pmis_app/PMIS/action_screens/safety_checklist_action.dart';
import 'package:ev_pmis_app/PMIS/authentication/login_register.dart';
import 'package:ev_pmis_app/PMIS/common_screen/otp_verification/send_otp.dart';
import 'package:ev_pmis_app/PMIS/provider/internet_provider.dart';
import 'package:ev_pmis_app/PMIS/common_screen/demand_energy/demandScreen.dart';
import 'package:ev_pmis_app/PMIS/admin/screen/quality_checklist/quality_home_admin.dart';
import 'package:ev_pmis_app/PMIS/common_screen/split_screen.dart';
import 'package:ev_pmis_app/PMIS/common_screen/citiespage/depot.dart';
import 'package:ev_pmis_app/PMIS/common_screen/overviewpage/overview.dart';
import 'package:ev_pmis_app/PMIS/user/screen/upload.dart';
import 'package:ev_pmis_app/PMIS/widgets/no_internet.dart';
import 'package:ev_pmis_app/PMIS/widgets/nodata_available.dart';
import 'package:flutter/material.dart';
import '../../O_AND_M/action__screen/monthlyManagement_action.dart';
import '../action_screens/jmr_action_screen.dart';
import 'package:provider/provider.dart';
import '../authentication/change_password.dart';
import '../common_screen/chatPage/feedback.dart';
import '../common_screen/citiespage/cities_home.dart';
import '../../O_AND_M/user/dailyreport/notification_userlist.dart';
import '../../O_AND_M/user/management_screen/breakdown_screen.dart';
import '../../O_AND_M/user/management_screen/charger_availabity_screen.dart';
import '../common_screen/o&m_pmis_screen.dart';
import '../common_screen/o&m_split_screen.dart';

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
            roleCentre: args["roleCentre"],
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
          return OverviewScreen(
            depoName: argument['depoName'],
            role: argument['role'],
            userId: argument['userId'],
            roleCentre: argument["roleCentre"],
            cityName: argument["cityName"],
          );

        case '/depotOverview':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DepotOverviewAction(
            roleCentre: argument["roleCentre"],
            userId: argument['userId'],
            depoName: argument['depoName'],
            role: argument['role'],
            cityName: argument['cityName'],
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
          final roleCentre = args["roleCentre"];
          return EVDashboardAction(
            roleCentre: roleCentre,
            role: role,
            userId: userId,
          );

        case '/demand':
          final args = settings.arguments as Map<String, dynamic>;
          final roleCentre = args["roleCentre"];
          return DemandEnergyScreen(
            roleCentre: roleCentre,
          );

        case '/splitDashboard':
          final args = settings.arguments as Map<String, dynamic>;
          return SplitScreen(
            roleCentre: args["roleCentre"],
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

        case '/user-list':
          return userList();

        case '/main_screen':
          Map<String, dynamic> mapData =
              settings.arguments as Map<String, dynamic>;
          return PmisAndOAndMScreen(
            roleCentre: mapData["roleCentre"],
            userId: mapData["userId"],
            role: mapData["role"],
          );

        case '/daiy_management':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return DailyManagementAction(
            roleCentre: argument['roleCentre'],
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/monthly_management':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;
          return MonthlyManagementAction(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
            roleCentre: argument['roleCentre'],
          );

        //management screen
        case '/breakdown_screen':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;

          return BreakdownScreen(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        case '/charger_availability_screen':
          Map<String, dynamic> argument =
              settings.arguments as Map<String, dynamic>;

          return ChargerAvailabilityScreen(
            userId: argument['userId'],
            cityName: argument['cityName'],
            depoName: argument['depoName'],
            role: argument['role'],
          );

        //O&M screen

        case "/charger":
          final args = settings.arguments as Map<String, dynamic>;
          final role = args["role"];
          final roleCentre = args["roleCentre"];
          final userId = args["userId"];
          final cityName = args["cityName"];
          final depoName = args["depoName"];

          return ChargerAvailabilityAction(
            roleCentre: roleCentre,
            userId: userId,
            cityName: cityName,
            depoName: depoName,
            role: role,
          );

        case "/breakdown":
          final args = settings.arguments as Map<String, dynamic>;
          final role = args["role"];
          final roleCentre = args["roleCentre"];
          final userId = args["userId"];
          final cityName = args["cityName"];
          final depoName = args["depoName"];

          return BreakdownAction(
            roleCentre: roleCentre,
            userId: userId,
            cityName: cityName,
            depoName: depoName,
            role: role,
          );

        case "/oAndMDashboard":
          final args = settings.arguments as Map<String, dynamic>;
          final role = args["role"];
          final roleCentre = args["roleCentre"];
          final userId = args["userId"];
          final cityName = args["cityName"];
          final depoName = args["depoName"];

          return OAndMDashboardScreen(
            roleCentre: roleCentre,
            userId: userId,
            cityName: cityName,
            depoName: depoName,
            role: role,
          );

        case "/oAndMsplitScreen":
          final args = settings.arguments as Map<String, dynamic>;
          final role = args["role"];
          final roleCentre = args["roleCentre"];
          final userId = args["userId"];
          // final cityName = args["cityName"];
          // final depoName = args["depoName"];

          return ManagementsplitScreen(
            roleCentre: roleCentre,
            userId: userId,
            role: role,
          );
      }

      return const NodataAvailable();
    });
  }
}
