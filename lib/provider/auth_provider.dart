import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final Auth _auth = Auth();
  User? _user;
  User? get user => _user;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Timer? _timer;

  AuthProvider() {
    _auth.authStateChanges.listen((user) async {
      _user = user;
      _isAuthenticated = user != null;
      if (_user != null) {
        _isEmailVerified = await _auth.checkEmailVerified();
      }
      notifyListeners();
    });
  }

  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    try {
      _errorMessage = null;
      await _auth.signUpWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;
      _isAuthenticated = _user != null;
      return _isAuthenticated;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    try {
      _errorMessage = null;
      _user = await _auth.signInWithEmailAndPassword(email, password);
      _isAuthenticated = _user != null;
      if (user != null && !isEmailVerified) {
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email is not verified. Please check your inbox.',
        );
      }
      return _isAuthenticated;
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-not-verified') {
        _errorMessage = e.message;
        return false;
      }
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
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

  Future<void> resendVerificationEmail() async {
    try {
      print('resend verification email');
      await _auth.resendVerificationEmail();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      _errorMessage = null;
      // User? user = await _auth.signInWithGoogle();
      if (user != null) {
        _user = user;
        _isAuthenticated = true;
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

}