import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else if (e.code =='email-already-in-use') {
        throw Exception('The email is already registered.');
      }
      throw Exception('An Error occurred during sign-up. $e');
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      String errorMessage = "An error occurred. Please try again later.";

      // Handle specific exception cases based on type or message
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = "The email address is badly formatted.";
            break;
          case 'user-disabled':
            errorMessage = "This user account has been disabled.";
            break;
          case 'user-not-found':
            errorMessage = "No user found for that email address.";
            break;
          case 'wrong-password':
            errorMessage = "Incorrect password provided. Please try again.";
            break;
          case 'invalid-credential':
            errorMessage = "Incorrect email or password. Please check your email and password and try again.";
            break;
          default:
            errorMessage = e.code;
            break;
        }
      } else if (e is FormatException) {
        errorMessage = "The email address is badly formatted.";
      } else if (e is Exception) {
        errorMessage = e.toString();
      }
      throw errorMessage;
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else {
        throw Exception('User not logged in or email already verified.');
      }
    } catch (e) {
      throw Exception('Error sending verification email: $e');
    }
  }

  Future<bool> checkEmailVerified() async{
    await currentUser?.reload();
    return currentUser?.emailVerified ?? false;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign-In aborted by user.");
        return null;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      print(userCredential.user?.displayName);
      return userCredential.user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> doesUserExist(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userDoc.exists;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }
}