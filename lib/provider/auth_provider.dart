import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_growth_plus/ui/main/add_child_data_screen.dart';

import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final Auth _auth = Auth();
  User? _user;
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  Timer? _timer;

  AuthProvider() {
    _auth.authStateChanges.listen((user) async {
      _user = user;
      if (_user != null) {
        _isEmailVerified = await _auth.checkEmailVerified();
      }
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    await _auth.signUpWithEmailAndPassword(email: email, password: password);
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AddChildDataScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  void startEmailVerificationCheck(Function onVerified) {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _auth.currentUser?.reload();
      _isEmailVerified = await _auth.checkEmailVerified();
      notifyListeners();
      if (_isEmailVerified) {
        timer.cancel();
        onVerified();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      User? user = await _auth.signInWithGoogle();
      if (user != null) {
        bool userExists = await _auth.doesUserExist(user.uid);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AddChildDataScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-In failed")),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error during Google Sign-In: $e");
      }
    }
  }

}