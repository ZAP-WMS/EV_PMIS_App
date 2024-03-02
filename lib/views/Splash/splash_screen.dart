import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/shared_preferences/shared_preferences.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/dailyreport/notification_userlist.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../viewmodels/push_notification.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message:${message.messageId}");
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
  bool user = false;
  String role = '';
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
                Navigator.pushReplacementNamed(context, '/user-list');
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

  // for handling  the notification in terminate state when app are terminated from background
  checkforInitialMessage() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification!.title ?? '',
        body: initialMessage.notification!.body ?? '',
        dataTitle: initialMessage.data['title'] ?? '',
        datBody: initialMessage.data['body'] ?? '',
      );
      if (initialMessage != null) {
        Navigator.pushReplacementNamed(context, '/user-list');
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => userList()
        //         // NotificationPage(notification: notification),
        //         ));
      }
      //    sendNotificationToUser(notification.title!, notification.body!);
      // if (mounted) {
      //   setState(() {
      //     _notificationInfo = notification;
      //     _totalNotification++;
      //   });
      // }
    }
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // NotificationSettings settings = await _messaging.requestPermission(
    //     alert: true, badge: true, provisional: true, sound: true);
    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     print('Message Title:${message.notification!.title}');

    //     PushNotification notification = PushNotification(
    //       title: message.notification!.title ?? '',
    //       body: message.notification!.body ?? '',
    //       dataTitle: message.data['title'] ?? '',
    //       datBody: message.data['body'] ?? '',
    //     );

    //     setState(() {
    //       _notificationInfo = notification;
    //       _totalNotification++;
    //     });
    //     if (notification != null) {
    //       // For Display the notificatio in Overlay
    //       showSimpleNotification(
    //         Text(_notificationInfo.title!),
    //         subtitle: Text(_notificationInfo.body ?? ''),
    //         background: blue,
    //         duration: Duration(seconds: 2),
    //       );
    //     }
    //   });
    // } else {
    //   print('user has decline permission');
    // }
  }

  @override
  void initState() {
    // _totalNotification = 0;
    registerNotification();
    checkforInitialMessage();

    //For handling notification app is in backgroung not terminated

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        dataTitle: message.data['title'] ?? '',
        datBody: message.data['body'] ?? '',
      );

      Navigator.pushReplacementNamed(context, '/user-list');

      // if (mounted) {
      //   setState(() {
      //     _notificationInfo = notification;
      //     _totalNotification++;
      //   });
      // }
    });
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);

    _getCurrentUser();
    // user = FirebaseAuth.instance.currentUser == null;
    Timer(
        const Duration(milliseconds: 2000),
        () => Navigator.pushNamedAndRemoveUntil(
            context,
            user ? '/splitDashboard' : '/login-page',
            arguments: role,
            (route) => false)

        //  Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) =>
        //         user ? GalleryPage() : const LoginRegister())),

        );
    // user ? const LoginRegister() : const HomePage())));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString('employeeId') != null) {
        if (mounted) {
          setState(() {
            userId = sharedPreferences.getString('employeeId');
            user = true;
          });
        }
        await checkRole(userId);
        StoredDataPreferences.saveString('role', role);
      }
    } catch (e) {
      user = false;
    }
  }

  Future<String> checkRole(String id) async {
    try {
      QuerySnapshot checkAdmin = await FirebaseFirestore.instance
          .collection('Admin')
          .where('Employee Id', isEqualTo: id)
          .get();

      if (checkAdmin.docs.isNotEmpty) {
        role = 'admin';
      } else {
        QuerySnapshot checkUser = await FirebaseFirestore.instance
            .collection('User')
            .where('Employee Id', isEqualTo: id)
            .get();

        if (checkUser.docs.isNotEmpty) {
          role = 'user';
        }
      }
      print(role);

      return role;
    } catch (e) {
      print('Error Occured while checking role - $e');
      return role;
    }
  }
}
