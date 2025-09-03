import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:QuickHire/Screens/fragment/Menu/aboutScreen.dart';
import 'package:QuickHire/Screens/fragment/bookmarkScreen.dart';
import 'package:share_plus/share_plus.dart';

import '../fragment/Menu/HelpScreen.dart';
import '../fragment/Menu/PrivacyPolicyScreen.dart';
import '../fragment/Menu/Review.dart';
import '../fragment/Menu/SettingsScreen.dart';
import '../fragment/homeScreen.dart';
import '../fragment/messagesScreen.dart';
import '../fragment/profileScreens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyMainScren extends StatefulWidget {
  const MyMainScren({super.key});

  @override
  State<MyMainScren> createState() => _MainScreenState();
}

class _MainScreenState extends State<MyMainScren>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      setState(() {
        _isMenuOpen = !_isMenuOpen;
        if (_isMenuOpen) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    } else {
      setState(() {
        _selectedIndex = index;
        _isMenuOpen = false;
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              Center(child: HomeScreen()),
              Center(child: bookmarkScreen()),
              Center(child: Container()),
              Center(child: MessageScreen()),
              Center(child: ProfileScreen()),
            ],
          ),
          if (_isMenuOpen) _buildAnimatedMenu(s),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: Colors.blueAccent,
        items: [
          TabItem(icon: Icons.home, title: s.home),
          TabItem(icon: Icons.bookmark_add, title: s.myJobs),
          const TabItem(icon: Icons.add, title: ' '), // Menu button; label hidden if desired.
          TabItem(icon: Icons.message, title: s.message),
          TabItem(icon: Icons.people, title: s.profile),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAnimatedMenu(AppLocalizations s) {
    return Positioned(
      bottom: 10,
      left: MediaQuery.of(context).size.width / 2 - 174, // Centering the menu
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 348,
          // Smaller menu width
          height: 200,
          // Reduced menu height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _fabItem(Icons.settings, s.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  }),
                  _fabItem(Icons.reviews, s.review, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewScreen(jobId: 1)),
                    );
                  }),
                  _fabItem(Icons.info, s.about, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => aboutScreen()),
                    );
                  }),
                  _fabItem(Icons.share,  s.share, () {
                    /*    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ()),
                        );*/
                    Share.share(
                        "🚀 Check out Jobber App! Find jobs easily. Download now: https://play.google.com/store/apps/details?id=com.yourapp.jobber",
                        subject: "Try the Jobber App for Job Search!");
                  }),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _fabItem(Icons.help_outline, s.help, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpScreen()),
                    );
                  }),
                  _fabItem(Icons.help_outline,s.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  }),
                  _fabItem(Icons.notifications, s.notify, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  }),
                  _fabItem(Icons.privacy_tip, s.privacy, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicyScreen()),
                    );
                  }),
                ],
              ),
             // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
  Widget _fabItem(IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            onTap(); // Call the passed function
            print("$label Clicked");
            setState(() {
              _isMenuOpen = false;
              _animationController.reverse();
            });
          },
          child: Container(
            padding: EdgeInsets.all(12),
            // Smaller button padding
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: Icon(icon, size: 24, color: Colors.white), // Smaller icons
          ),
        ),
        SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        // Smaller text
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
