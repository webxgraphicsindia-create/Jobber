import 'package:flutter/material.dart';
import 'package:QuickHireRecruiter/Module/ProfileManager.dart';
import 'package:QuickHireRecruiter/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api/GoogleSignInApi.dart';
import 'ChangePasswordScreen.dart';
import 'EditProfileScreen.dart';
import 'SettingsScreen.dart';


class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {

  Future<void> __signOut() async {
    // Sign out from Google
    await GoogleSignInApi().signOutFromGoogle(context);
    // Additional steps for sign-out (e.g., clear other data if needed)
    print("User signed out");
  }

  Future<void> _signOut() async {
    // Clear the stored access token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');

    // Optionally, show a message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Logged out successfully!",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green.shade100,
              child: const Icon(Icons.person, size: 60, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
                ProfileManager.userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              ProfileManager.userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.green),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.green),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock, color: Colors.green),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Logout"),
                          content: const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customGreen,
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop(); // Close the dialog
                                await _signOut(); // Clear token and show snack
                                await __signOut(); // Google sign-out
                                await ProfileManager.clearProfileData(); // Clear profile info

                                // Navigate to login screen or pop back to root (optional)
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                              },
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

