import 'package:flutter/material.dart';
import 'package:QuickHireRecruiter/Screens/Auth/SignupScreen.dart';
import 'package:QuickHireRecruiter/Screens/Auth/loginScreen.dart';

class TasktugasAuthScreen extends StatefulWidget {
  const TasktugasAuthScreen({Key? key}) : super(key: key);

  @override
  State<TasktugasAuthScreen> createState() => _TasktugasAuthScreenState();
}

class _TasktugasAuthScreenState extends State<TasktugasAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // We have two tabs: Login and Sign Up
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo / Title
                Text(
                  'QuickHire Recruiter',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  'Welcome to QuickHire Recruiter',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  'Find, Hire, and Grow – Start Building Your Team Today.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),

                // Tab bar: Login / Sign Up
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey.shade600,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Sign Up'),
                    ],
                  ),
                ),

                // Expanded area for the two tab views
                Expanded(
                  child: TabBarView(
                    children: [
                      // Login tab
                      LoginTab(),

                      // Sign Up tab
                      SignUpTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

