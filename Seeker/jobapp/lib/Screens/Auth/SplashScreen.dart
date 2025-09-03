import 'dart:async';
import 'package:flutter/material.dart';
import 'package:QuickHire/Screens/MainScreen/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../JsonModels/ProfileManager.dart';
import 'OnboardingScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MySplashscreen extends StatefulWidget {
  const MySplashscreen({super.key});

  @override
  State<MySplashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<MySplashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyMainScren()),
      );
      ProfileManager.loadProfileData();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyOnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    if (local == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                local.appName, // Localized 'Jobber'
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                local.createdBy, // Localized 'Created by BlueVision Softech'
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
