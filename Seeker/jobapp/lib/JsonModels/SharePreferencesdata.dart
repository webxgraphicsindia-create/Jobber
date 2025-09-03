import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SharePreferencesdata {

  static Future<void> saveProfileData(Map<String, dynamic> profileData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_data', jsonEncode(profileData)); // ✅ Save as JSON
  }

}