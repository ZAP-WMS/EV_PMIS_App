import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/provider/All_Depo_Select_Provider.dart';
import 'package:ev_pmis_app/provider/checkbox_provider.dart';
import 'package:ev_pmis_app/provider/cities_provider.dart';
import 'package:ev_pmis_app/provider/demandEnergyProvider.dart';
import 'package:ev_pmis_app/provider/energy_provider_admin.dart';
import 'package:ev_pmis_app/provider/energy_provider_user.dart';
import 'package:ev_pmis_app/provider/internet_provider.dart';
import 'package:ev_pmis_app/provider/key_provider.dart';
import 'package:ev_pmis_app/provider/scroll_top_provider.dart';
import 'package:ev_pmis_app/provider/selected_row_index.dart';
import 'package:ev_pmis_app/provider/summary_provider.dart';
import 'package:ev_pmis_app/route/routegenerator.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/models/push_notification.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notiification/notification_service.dart';

@pragma('vm:entry-point')
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

void main() async {
  Future.delayed(Duration.zero, () async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  FirebaseMessaging.instance.isAutoInitEnabled;
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

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) async {
      await OpenFile.open(details.payload!);
    },
  );
  runApp(const MyApp());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  String? userId;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<String> citiesList = [];

  // This widget is the root of your application.

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    getUserId().whenComplete(() {
      verifyAndSaveCities();
    });

    super.initState();
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      print('UserId - $value');
      // setState(() {});
    });
  }

  verifyAndSaveCities() async {
    await verifyProjectManager();
  }

  Future<void> verifyProjectManager() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('roles', arrayContains: 'Project Manager')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.data()).toList();

    for (int i = 0; i < tempList.length; i++) {
      print('userId${tempList[i]['userId'].toString()}');
      if (tempList[i]['userId'].toString() == userId.toString()) {
        print('print${tempList[i]['cities'][0]}');
        for (int j = 0; j < tempList[i]['cities'].length; j++) {
          citiesList.add(tempList[i]['cities'][j]);
          await _saveCities(citiesList);
          print('rtretrtretret');
        }

        _firebaseMessaging.getToken().then((value) {
          print("token::::$value");
          NotificationService().saveTokenToFirestore(userId!, value);
          // sendNotificationToUser(value!, 'title', 'body');
        });
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          //handle incoming messages
          print('receive message${message.notification?.body}');
        });
      }
    }
  }

  _saveCities(List<String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String citiesString = jsonEncode(data);
    await prefs.setStringList('cities', data);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CitiesProvider()),
        ChangeNotifierProvider(create: (context) => SummaryProvider()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => KeyProvider()),
        ChangeNotifierProvider(create: (context) => EnergyProvider()),
        ChangeNotifierProvider(create: (context) => SelectedRowIndexModel()),
        ChangeNotifierProvider(create: (context) => DemandEnergyProvider()),
        ChangeNotifierProvider(create: (context) => AllDepoSelectProvider()),
        ChangeNotifierProvider(create: (context) => ScrollProvider()),
        ChangeNotifierProvider(create: (context) => EnergyProviderAdmin()),
        ChangeNotifierProvider(create: (context) => CheckboxProvider())
      ],
      child: OverlaySupport(
        child: GetMaterialApp(
          // initialRoute: '/splash',
          initialRoute:
              //'/user-list',
               "/login-page",
              //'/main_screen',
          // '/daiy_management',
          //  '/demand',
          // '/splash-screen',
          // all the pages of routes are declared here
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          title: 'TP-EV-PMIS',
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: 'Montserrat',
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            dividerColor: const Color.fromARGB(255, 2, 42, 75),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(
                  color: blue,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(
                  color: blue,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusColor: black,
              // labelStyle: Colors.b
            ),
          ),
        ),
      ),
    );
  }
}
