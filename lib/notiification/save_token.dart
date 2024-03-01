import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _tokensCollection =
      FirebaseFirestore.instance.collection('tokens');

  Future<void> saveToken(String userId, String token) async {
    await _tokensCollection.doc(userId).set({
      'token': token,
      'timestamp': FieldValue.serverTimestamp(), // Optionally store a timestamp
    });
  }
}
