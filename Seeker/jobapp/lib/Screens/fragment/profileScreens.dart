import 'package:flutter/material.dart';
import 'package:QuickHire/JsonModels/ProfileManager.dart';
import 'package:QuickHire/Screens/fragment/profileEditscreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/*
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Screen', style: TextStyle(fontSize: 24)));
  }
}*/

/*
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {


  String imageUrl ='';
  String? useremail = ProfileManager.userEmail;
  String? username = ProfileManager.userName;


  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  const Text(
                    "Jobber",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // Profile Card
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                        */
/*  ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            */ /*
*/
/*child: Image.asset(
                              "assets/profile.jpg", // Replace with NetworkImage if needed
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),*/ /*
*/
/*
                          ),*/ /*


                          ClipOval(
                            child: Image.network(
                              imageUrl,
                              width: 70, // Size of the image
                              height: 70,
                              fit: BoxFit.cover, // Crop the image to fit
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.person, size: 70, color: Colors.grey); // Default icon if image fails
                              },
                            ),
                          ),



                          const SizedBox(height: 8),
                          Text( username! ,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(useremail!,
                              style: TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 10),

                          // Job Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _statusBox("Applied", "20"),
                              _statusBox("Interview", "8"),
                              _statusBox("Offer", "2"),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _customButton("Resume", Colors.blue),
                              const SizedBox(width: 10),
                              _customButton("Share", Colors.blue),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Profile Performance

            // Basic Details
            _sectionTitle("Basic Details"),
            _basicDetailItem(Icons.work, " Fresher"),
            _basicDetailItem(Icons.location_on, " Ballarpur, INDIA"),
            _basicDetailItem(Icons.phone, " +91 7387784164"),
            _basicDetailItem(Icons.email, " mohitlengure2002@gmail.com"),
            _basicDetailItem(Icons.account_circle, " mohitlengure"),
            _basicDetailItem(Icons.link, " mohitlengure2002"),

            // Improve job matches
            _sectionTitle("Improve your job matches"),

            // Upgrade Skills
            _sectionTitle("Upgrade Your Skills"),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Status Box
  Widget _statusBox(String title, String count) {
    return Expanded(
      child: Column(
        children: [
          Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Helper Widget for Custom Buttons
  Widget _customButton(String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  // Section Title Widget
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  // Basic Detail Item Widget
  Widget _basicDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
*/
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageUrl = '';
  String? useremail = ProfileManager.userEmail;
  String? username = ProfileManager.userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildProfileCard(),
            _buildSection("Basic Details", _basicDetails()),
            _buildSection("Improve Your Job Matches", _improveJobMatches()),
            _buildSection("Upgrade Your Skills", _upgradeSkills()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final s = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 14),
          Text(
            s.appName, // <-- This is now localized!
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.network(
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, size: 90, color: Colors.grey);
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            username ?? "User Name",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            useremail ?? "user@example.com",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          SizedBox(height: 10),
          _customButton(
            "Edit",
            Colors.blue,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => profileEditscreen()),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildProfileCard() {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statusBox("Applied", "20"),
                _statusBox("Interview", "8"),
                _statusBox("Offer", "2"),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _customButton("Resume", Colors.blue, () {
                  print("Resume Clicked ");
                },),
                SizedBox(width: 10),
                _customButton("Share", Colors.green, () {
                  print("Share Clicked ");
                },),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBox(String title, String count) {
    return Column(
      children: [
        Text(count,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _customButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Divider(),
          content,
        ],
      ),
    );
  }

  Widget _basicDetails() {
    return Column(
      children: [
        _basicDetailItem(Icons.work, " Fresher"),
        _basicDetailItem(Icons.location_on, " Pune, INDIA"),
        _basicDetailItem(Icons.phone, " +91 7387784164"),
        _basicDetailItem(Icons.email,  username ?? "User Name" ),
        _basicDetailItem(Icons.account_circle,  username ?? "User Name"),
        _basicDetailItem(Icons.link,  username ?? "User Name"),
      ],
    );
  }

  Widget _improveJobMatches() {
    return Text("Enhance your profile to receive better job recommendations.",
        style: TextStyle(fontSize: 14, color: Colors.grey));
  }

  Widget _upgradeSkills() {
    return Text("Explore courses to boost your career.",
        style: TextStyle(fontSize: 14, color: Colors.grey));
  }

  Widget _basicDetailItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
