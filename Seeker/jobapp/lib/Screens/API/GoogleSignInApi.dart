import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:QuickHire/Screens/Auth/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInApi {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  // Sign in with Google
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        // Save email and name to SharedPreferences
        await _saveUserData(user);
        return user;
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      return null;
    }
    return null;
  }

  // Save the user's email and name to SharedPreferences
  Future<void> _saveUserData(GoogleSignInAccount user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user.email);
    await prefs.setString('name', user.displayName ?? 'No Name');
  }

  // Retrieve the stored email and name from SharedPreferences
  Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? name = prefs.getString('name');
    return {'email': email, 'name': name};
  }

 /* // Sign out
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('name');

  }*/

  // Sign-Out and Navigate to Login Screen
  Future<void> signOutFromGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signOut(); // Google Sign-Out
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all stored data

      // Navigate to Login Screen & remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyLogin()),
            (route) => false,
      );

      print("User signed out and data cleared!");
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
