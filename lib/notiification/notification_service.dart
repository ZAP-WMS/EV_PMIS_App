import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final CollectionReference _tokensCollection =
      FirebaseFirestore.instance.collection('tokens');

  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    await getFCMToken();
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

  Future<void> backgroundHandler(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
  }
}
