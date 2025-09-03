import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Module/ProfileManager.dart';
import '../../constants/colors.dart';
import '../MyMainScren.dart';
import 'TasktugasAuthScreen.dart';
import 'loginScreen.dart';

class MySplashscreen extends StatefulWidget {
  const MySplashscreen({super.key});

  @override
  State<MySplashscreen> createState() => _MySplashscreenState();
}

class _MySplashscreenState extends State<MySplashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for logo scaling animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Navigate to next screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Check if access token exists and navigate accordingly
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token != null && token.isNotEmpty) {
      print("Token found: $token");
      await ProfileManager.loadProfileData(); // Load profile data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyMainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TasktugasAuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.customGreen,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated logo using ScaleTransition and Hero widget
              /*ScaleTransition(
                scale: _scaleAnimation,
                child: Hero(
                  tag: 'appLogo',
                  child: Image.asset(
                    'assets/logo.png', // Your logo file
                    width: 150,
                    height: 150,
                  ),
                ),
              ),*/
              const SizedBox(height: 20),
              const Text(
                'QuickHire Recruiter',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Created by BlueVision Softech',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
