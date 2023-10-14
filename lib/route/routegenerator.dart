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
import 'package:ev_pmis_app/screen/Detailedreport/detailed_Eng.dart';
import 'package:ev_pmis_app/screen/citiespage/cities_home.dart';
import 'package:ev_pmis_app/screen/closureReport/closuretable.dart';

import 'package:ev_pmis_app/screen/dailyreport/daily_project.dart';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:ev_pmis_app/screen/homepage/home_page.dart';
import 'package:ev_pmis_app/screen/materialprocurement/material_vendor.dart';
import 'package:ev_pmis_app/screen/monthlyreport/monthly_project.dart';
import 'package:ev_pmis_app/screen/overviewpage/depot_overview.dart';
import 'package:ev_pmis_app/screen/overviewpage/depot_overviewtable.dart';
import 'package:ev_pmis_app/screen/overviewpage/overview.dart';
import 'package:ev_pmis_app/screen/safetyreport/safetyfield.dart';
import 'package:flutter/material.dart';
import '../action_screens/jmr_action_screen.dart';
import '../screen/closureReport/closurefield.dart';
import '../screen/planning/project_planning.dart';
import '../screen/qualitychecklist/quality_home.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/splash-screen':
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case '/login-page':
        return MaterialPageRoute(builder: (context) => const LoginRegister());
      case '/gallery':
        return MaterialPageRoute(builder: (context) => GalleryPage());
      case '/homepage':
        return MaterialPageRoute(
            builder: (context) => HomePage(
                  role: args.toString(),
                ));

      case '/cities-page':
        return MaterialPageRoute(
            builder: (context) => CitiesHome(
                  role: args.toString(),
                ));

      // case '/depotOverview':
      //   return MaterialPageRoute(
      //       builder: (context) => DepotOverview(depoName: args.toString()));

      case '/depotOverview':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => DepotOverviewAction(
                depoName: arguments['depoName'].toString(),
                role: arguments['role']));

      case '/overview page':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => OverviewPage(
                  depoName: arguments['depoName'].toString(),
                  role: arguments['role'].toString(),
                ));
      // case '/overview-table':
      //   return MaterialPageRoute(
      //       builder: (context) => OverviewTable(depoName: args.toString()));

      // case '/planning-page':
      //   return MaterialPageRoute(
      //       builder: (context) => KeyEvents(
      //             depoName: args.toString(),
      //           ));

      case '/planning-page':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProjectPlanningAction(
                depoName: arguments['depoName'].toString(),
                role: arguments['role']));

      // case '/material-page':
      //   return MaterialPageRoute(
      //       builder: (context) =>
      //           MaterialProcurement(depoName: args.toString()));

      case '/material-page':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => MaterialProcurementAction(
                depoName: arguments['depoName'].toString(),
                role: arguments['role']));

      // case '/daily-report':
      //   return MaterialPageRoute(
      //     builder: (context) => DailyProject(depoName: args.toString()),
      //   );

      case '/daily-report':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => DailyProjectAction(
              depoName: arguments['depoName'].toString(),
              role: arguments['role']),
        );

      // case '/monthly-report':
      //   return MaterialPageRoute(
      //     builder: (context) => MonthlyProject(depoName: args.toString()),
      //   );

      case '/monthly-report':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => MonthlyReportAction(
              depoName: arguments['depoName'].toString(),
              role: arguments['role']),
        );

      // case '/detailed-page':
      //   return MaterialPageRoute(
      //     builder: (context) => DetailedEng(depoName: args.toString()),
      //   );

      case '/detailed-page':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => DetailEngineeringAction(
              depoName: arguments['depoName'].toString(),
              role: arguments['role']),
        );

      // case '/safety-page':
      //   return MaterialPageRoute(
      //       builder: (context) => SafetyField(depoName: args.toString()));

      case '/safety-page':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => SafetyChecklistAction(
                  depoName: arguments['depoName'].toString(),
                  role: arguments['role'],
                ));

      // case '/quality-page':
      //   return MaterialPageRoute(
      //       builder: (context) => QualityHome(
      //             depoName: args.toString(),
      //           ));

      case '/closure-page':
        return MaterialPageRoute(
            builder: (context) => ClosureField(
                  depoName: args.toString(),
                ));
      // case '/closure-table':
      //   return MaterialPageRoute(
      //       builder: (context) => ClosureTable(
      //             depoName: args.toString(),
      //           ));

      case '/jmrPage':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => JmrActionScreen(
                  depoName: arguments['depoName'].toString(),
                  role: arguments['role'],
                ));

      case '/closure-table':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClosureReportAction(
                  depoName: arguments['depoName'].toString(),
                  role: arguments['role'],
                ));

      case '/quality-page':
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => QualityChecklistAction(
                  depoName: arguments['depoName'].toString(),
                  role: arguments['role'],
                ));
    }
  }
}
