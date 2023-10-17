import 'package:ev_pmis_app/Splash/splash_screen.dart';
import 'package:ev_pmis_app/authentication/login_register.dart';
import 'package:ev_pmis_app/provider/internet_provider.dart';
import 'package:ev_pmis_app/screen/Detailedreport/detailed_Eng.dart';
import 'package:ev_pmis_app/screen/citiespage/cities_home.dart';
import 'package:ev_pmis_app/screen/closureReport/closuretable.dart';

import 'package:ev_pmis_app/screen/dailyreport/daily_project.dart';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:ev_pmis_app/screen/homepage/home_page.dart';
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
import '../screen/planning/project_planning.dart';
import '../screen/qualitychecklist/quality_home.dart';

import '../screen/jmrPage/jmr.dart';

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

        case '/material-excelpage':
          return UploadMaterial(depoName: args.toString());

        case '/daily-report':
          return DailyProject(depoName: args.toString());

        case '/monthly-report':
          return MonthlyProject(depoName: args.toString());

        case '/detailed-page':
          return DetailedEng(
            depoName: args.toString(),
          );

        case '/safety-page':
          return SafetyField(depoName: args.toString());

        case '/quality-page':
          return QualityHome(depoName: args.toString());

        case '/testing-page':
          return TestingPage(depoName: args.toString());
        case '/closure-page':
          return ClosureField(
            depoName: args.toString(),
          );
        case '/closure-table':
          return ClosureTable(
            depoName: args.toString(),
          );

        case '/jmrPage':
          return JmrPage(cityName: args.toString(), depoName: args.toString());

        case '/chatpage':
          return ChatPage(depoName: args.toString());
      }
      return const NodataAvailable();
    });
  }
}
