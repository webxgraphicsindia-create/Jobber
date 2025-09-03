import 'package:flutter/material.dart';
import 'package:QuickHireRecruiter/Module/ProfileManager.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import '../constants/colors.dart';
import 'Fragments/HomeFragment.dart';
import 'Fragments/JobsFragment.dart';
import 'Fragments/MessageScreen.dart';
import 'Fragments/ProfileFragment.dart';

class MyMainScreen extends StatefulWidget {
  const MyMainScreen({Key? key}) : super(key: key);

  @override
  State<MyMainScreen> createState() => _MyMainScreenState();
}

class _MyMainScreenState extends State<MyMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _fragments = [
    const HomeFragment(),
    const JobsFragment(),
    MessageScreen(),
     ProfileFragment(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    ProfileManager.loadProfileData(); // ✅ Load profile first
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('QuickHire Recruiter'),
        backgroundColor: AppColors.customGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Navigate to profile screen
            },
          ),
        ],
      ),
      body: _fragments[_selectedIndex],
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: Colors.white,
        waterDropColor: AppColors.customGreen,
        inactiveIconColor: Colors.grey.shade400,
        iconSize: 30,
        onItemSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        barItems: [
          BarItem(
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.work,
            outlinedIcon: Icons.work_outline,
          ),
          BarItem(
            filledIcon: Icons.forum,
            outlinedIcon: Icons.forum_outlined,
          ),
          BarItem(
            filledIcon: Icons.person,
            outlinedIcon: Icons.person_outline,
          ),
        ],
      ),
    );
  }
}
