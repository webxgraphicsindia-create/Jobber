import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileManager {
  static String userId = "";
  static String userName = "";
  static String userEmail = "";
  static String address = "";
  static String? userPhone;
  static String? profileImage;
  static String? accesstoken;

  static Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileJson = prefs.getString('profile_data');

    if (profileJson != null) {
      Map<String, dynamic> profileData = jsonDecode(profileJson);

      // ✅ Store values in static variables
      userId = profileData["id"] ?? "";
      userName = profileData["name"] ?? "Guest";
      userEmail = profileData["email"] ?? "";
      userPhone = profileData["phone"];
      profileImage = profileData["profile_image"];
      accesstoken = profileData["access_token"];

      print(userEmail);
      print(userPhone);
      print(userPhone);


      print("Profile Loaded: $userName");
    } else {
      print("No profile data found.");
    }
  }


  static Future<void> clearProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_data');

    // ✅ Reset static variables
    userId = "";
    userName = "";
    address = "";
    userEmail = "";
    userPhone = null;
    profileImage = null;
    accesstoken = null;

    print("Profile Cleared");
  }
}
