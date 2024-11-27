import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to store additional user data (phone number, full name)
  Future<void> storeUserData(String fullName, String phoneNumber, String email) async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is currently signed in");
    }

    try {
      await _db.collection('users').doc(user.uid).set({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
