import 'package:ev_pmis_app/provider/cities_provider.dart';
import 'package:ev_pmis_app/provider/internet_provider.dart';
import 'package:ev_pmis_app/provider/summary_provider.dart';
import 'package:ev_pmis_app/route/routegenerator.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  // its used for status bar color

  Future.delayed(Duration.zero, () async {
    //to run async code in initState
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    // enables secure mode for app, disables screenshot, screen recording
  });
// here i have initialize my firebase
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: blue));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]);

  await Firebase.initializeApp();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CitiesProvider()),
        ChangeNotifierProvider(create: (context) => SummaryProvider()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider())
      ],
      child: GetMaterialApp(
        // initialRoute: '/jmrPage',
        initialRoute: '/splash-screen',
        // all the pages of routes are declared here
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: GoogleFonts.quicksand().fontFamily),
        //home: LoginRegister()
      ),
    );
  }
}
