import 'dart:convert';

import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

Future<void> sendNotificationToUser(
    String userToken, String title, String body) async {
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
      'to': userToken,
    };
    // Send the POST request to the FCM endpoint
    final response =
        await http.post(url, headers: headers, body: jsonEncode(payload));

    if (response.statusCode == 200) {
      showSimpleNotification(Text('data'),
          subtitle: Text('data'),
          background: yellow,
          duration: Duration(seconds: 2));
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
}
