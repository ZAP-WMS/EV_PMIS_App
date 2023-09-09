import 'package:ev_pmis_app/provider/cities_provider.dart';
import 'package:ev_pmis_app/provider/summary_provider.dart';
import 'package:ev_pmis_app/route/routegenerator.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  // its used for status bar color
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: blue));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]);

// here i have initialize my firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        ChangeNotifierProvider(
          create: (context) => SummaryProvider(),
        )
      ],
      child: GetMaterialApp(
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
