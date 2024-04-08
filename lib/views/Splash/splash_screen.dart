import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/shared_preferences/shared_preferences.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/push_notification.dart';
import '../dailyreport/notification_userlist.dart';

late FirebaseMessaging _messaging;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationSettings settings = await _messaging.requestPermission(
      alert: true, badge: true, provisional: true, sound: true);
  await Firebase.initializeApp();

  RemoteMessage? initializeMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initializeMessage != null) {
    PushNotification notification = PushNotification(
      title: initializeMessage.notification!.title ?? '',
      body: initializeMessage.notification!.body ?? '',
      dataTitle: initializeMessage.data['title'] ?? '',
      datBody: initializeMessage.data['body'] ?? '',
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  dynamic userId = '';
  bool _isNotificationPage = false;
  late SharedPreferences sharedPreferences;

  late FirebaseMessaging _messaging;
  // int _totalNotification = 0;
  // PushNotification? _notificationInfo;

// WHEN APP IS OPENED
  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await _messaging.requestPermission(
        alert: true, badge: true, provisional: true, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Message Title:${message.notification!.title}');

        PushNotification notification = PushNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          dataTitle: message.data['title'] ?? '',
          datBody: message.data['body'] ?? '',
        );
        if (notification != null) {
          // For Display the notification in Overlay
          print(notification.title!);
          //   sendNotificationToUser(notification.title!, notification.body!);
          showSimpleNotification(Text(notification.title!),
              subtitle: Text(notification.body ?? ''),
              background: blue,
              duration: const Duration(seconds: 2),
              trailing: Builder(builder: (context) {
            return TextButton(
              child: Text(
                'See User',
                style: TextStyle(color: white, fontSize: 16),
              ),
              onPressed: () {
                // Add your action here
                print('Notification tapped!');
                // Navigate to the desired screen, for example
                Navigator.pushReplacementNamed(
                  context,
                  '/user-list',
                );
              },
            );
          }));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => userList()
          //         // NotificationPage(notification: notification),
          //         ));

          // if (mounted) {
          //   setState(() {
          //     _notificationInfo = notification;
          //     _totalNotification++;
          //   });
        }
      });
    } else {
      print('user has decline permission');
    }
  }

  // for handling  the notification in terminate state when app are terminated not in the background
  checkforInitialMessage() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/user-list');
      PushNotification notification = PushNotification(
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        dataTitle: message.data['title'] ?? '',
        datBody: message.data['body'] ?? '',
      );
      setState(() {
        _isNotificationPage = true;
      });
    }
  }

  List<String> citiesList = [];

  @override
  void initState() {
    // _totalNotification = 0;
    // _loadCities();
    registerNotification();
    checkforInitialMessage();
    print(citiesList);

    //For handling notification app is in backgroung
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => userList(),
            ));

        PushNotification notification = PushNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          dataTitle: message.data['title'] ?? '',
          datBody: message.data['body'] ?? '',
        );
        // save the current context
        BuildContext? currentContext = context;
        Navigator.pushReplacementNamed(
          currentContext,
          '/user-list',
        );
        setState(() {
          _isNotificationPage = true;
        });
      }
    });

    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);

    // user = FirebaseAuth.instance.currentUser == null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentUser();
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            Positioned.fill(
                child: Center(
              child: Image.asset(
                "assets/Tata-Power.jpeg",
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
              ),
            )),
            // Positioned(
            //   bottom: 70,
            //   left: 0,
            //   right: 0,
            //   child: Text(
            //     "TATA POWER",
            //     style: GoogleFonts.workSans(
            //       fontSize: 32.0,
            //       color: Colors.white.withOpacity(0.87),
            //       letterSpacing: -0.04,
            //       height: 5.0,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  void _getCurrentUser() async {
    bool user = false;

    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString('employeeId') != null) {
        userId = sharedPreferences.getString('employeeId');
        user = true;
      }

      if (!_isNotificationPage) {
        String role = await AuthService().getUserRole();
        // Add a delay before navigating to the main page
        await Future.delayed(
          const Duration(milliseconds: 1500),
          () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              user ? '/splitDashboard' : '/login-page',
              arguments: {"role": role, "userId": userId},
              (route) => false,
            );
          },
        );
      } else {
        Navigator.pushNamed(context, '/user-list');
      }
    } catch (e) {
      print("Error Occured on Spash Screen - $e");
    }
  }
}
