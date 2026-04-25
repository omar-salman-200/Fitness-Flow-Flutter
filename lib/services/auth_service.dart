import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Required for ChangeNotifier
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _lastError;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with Email & Password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } catch (e) {
      print("Email login error: $e");
      return null;
    }
  }

  // Sign up with Email & Password
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      // Step 1: Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = result.user;
      if (user != null) {
        // Step 2: Save basic profile to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'name': 'New User', // default name — user can change later in Profile
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      _lastError = e.toString();
      print("Sign up error: $_lastError");
      return null;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }

  // Forgot Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      print("Forgot password error: $e");
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners(); // Optional: if you listen to auth state
  }
}