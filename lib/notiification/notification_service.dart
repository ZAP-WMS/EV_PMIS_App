import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("message Received");
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final CollectionReference _tokensCollection =
      FirebaseFirestore.instance.collection('tokens');

  static Future<void> initialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("Notification Initialize");
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen((message) {
        log("message Received");
      });
    }
  }

  Future<String?> getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    // print("FCM Token: $token");
    return token;
  }

  Future<void> saveTokenToFirestore(String userId, String? token) async {
    final DocumentSnapshot<Object?> snapshot =
        await _tokensCollection.doc(userId).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    String? fetchedToken = data?['token'];

    if (token != null) {
      if (!snapshot.exists) {
        await _tokensCollection.doc(userId).set({
          'token': token,
          'createdAt':
              FieldValue.serverTimestamp(), // Optionally store a timestamp
        });
      }
      if (fetchedToken != token) {
        await _tokensCollection.doc(userId).update({
          'token': token,
          'createdAt':
              FieldValue.serverTimestamp(), // Optionally store a timestamp
        });
      }
    }
  }
}
