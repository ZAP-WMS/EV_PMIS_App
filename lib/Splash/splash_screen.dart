import 'dart:async';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Authentication/login_register.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool user = false;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();

    _getCurrentUser();
    // user = FirebaseAuth.instance.currentUser == null;
    Timer(
        const Duration(milliseconds: 2000),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                user ? const GalleryPage() : const LoginRegister())));
    // user ? const LoginRegister() : const HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
              child: Center(
            child: Image.asset("assets/Tata-Power.jpeg"),
          )),
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Text(
              "TATA POWER",
              style: GoogleFonts.workSans(
                fontSize: 32.0,
                color: Colors.white.withOpacity(0.87),
                letterSpacing: -0.04,
                height: 5.0,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString('employeeId') != null) {
        setState(() {
          user = true;
        });
      }
    } catch (e) {
      user = false;
    }
    // Timer(
    //     const Duration(milliseconds: 1000),
    //     () => Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (BuildContext context) => LoginRegister()
    //             // user ? const HomePage() : const LoginRegister()
    //             )));
  }
}
