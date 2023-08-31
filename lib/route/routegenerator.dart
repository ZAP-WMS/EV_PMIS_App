import 'package:ev_pmis_app/Splash/splash_screen.dart';
import 'package:ev_pmis_app/authentication/login_register.dart';
import 'package:ev_pmis_app/screen/citiespage/cities_home.dart';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:ev_pmis_app/screen/homepage/home_page.dart';
import 'package:ev_pmis_app/screen/materialprocurement/material_vendor.dart';
import 'package:ev_pmis_app/screen/overviewpage/depot_overview.dart';
import 'package:ev_pmis_app/screen/overviewpage/depot_overviewtable.dart';
import 'package:ev_pmis_app/screen/overviewpage/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final args1 = settings.arguments;

    switch (settings.name) {
      case '/splash-screen':
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case '/login-page':
        return MaterialPageRoute(builder: (context) => const LoginRegister());
      case '/gallery':
        return MaterialPageRoute(builder: (context) => const GalleryPage());
      case '/homepage':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/cities-page':
        return MaterialPageRoute(builder: (context) => const CitiesHome());
      case '/depotOverview':
        return MaterialPageRoute(
            builder: (context) => DepotOverview(
                cityName: args.toString(), depoName: args.toString()));
      case '/overview page':
        return MaterialPageRoute(
            builder: (context) => OverviewPage(
                  depoName: args1.toString(),
                ));
      case '/overview-table':
        return MaterialPageRoute(
            builder: (context) => OverviewTable(depoName: args.toString()));

      case '/material-page':
        return MaterialPageRoute(
            builder: (context) => MaterialProcurement(
                  depoName: args.toString(),
                  cityName: args.toString(),
                ));
    }
  }
}
