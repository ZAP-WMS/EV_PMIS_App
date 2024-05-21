import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

Future<void> sendNotificationToUser(String title, String body) async {
  List<String> tokens = [];
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('tokens').get();

  querySnapshot.docs.forEach((doc) {
    tokens.add(doc.data()['token']);
  });
  try {
    // Define the FCM endpoint
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    print(url);

    // Define the request headers, including the authorization token
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAt3Gu5oU:APA91bGe99ACoNokwnxLJ-jqFyImIAxkOh3xTLAYp-rtMkYFHgHgw1Udj1G30bnD68cQ9NrCdFIwMp3CLeWvcpT2u-rGq_eu4TbyE02N1thaXUKtbn8bZFPCrOA9RkfmBPILUK1ItTLt',
    };

    // Define the message payload
    final payload = {
      'notification': {
        'title': title,
        'body': body,
      },
      'to': tokens
      //  [
      //   'd_-fL2FtTDyjKWYe2Ve__t:APA91bEuaW1Utyt7CBXmBbL7kjpH7EfnuDx3ULmxmrk2BFfBoQNjGKlILyLcS5wJURhNEZVT2mzUmHYHh_UdL7tcrsbhGa_1k9t75i_aKIrpIdUZD1wYANHPoHAA23K_kXGbMmRUgQBI',
      //   'fRa0mqvlR4mhLlhvrvwzaE:APA91bH1o5zpSMv50hTumJdGtZ_nCrNNL3KqzXqNrhCLFs9epm-FsUn8b9Zd2bA-B1Zh039M2rxIgZ-pmbLokbFQLljHVPiAJbVDNST_HGEyRSJlufpuJBfhxLRXfCsAcPkwVOr-i8I0'
      // ].toString(),
    };
    // Send the POST request to the FCM endpoint
    final response =
        await http.post(url, headers: headers, body: jsonEncode(payload));

    if (response.statusCode == 200) {
      showSimpleNotification(Text(title),
          subtitle: Text(body),
          background: blue,
          duration: const Duration(seconds: 2));
      // showSimpleNotification(
      //     Text(notification.title!),
      //     subtitle: Text(notification.body ?? ''),
      //     background: blue,
      //     duration: const Duration(seconds: 2),
      //   );
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }

  // Future<List<String>> getTokensFromFirestore() async {
  //   List<String> tokens = [];

  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await FirebaseFirestore.instance.collection('tokens').get();

  //     querySnapshot.docs.forEach((doc) {
  //       tokens.add(doc.data()['token']);
  //     });
  //   } catch (e) {
  //     print('Error retrieving tokens: $e');
  //   }

  //   return tokens;
  // }
}
