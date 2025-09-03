import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class aboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Jobber"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.work, size: 80, color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to Jobber",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Jobber is your ultimate job search companion, helping you connect with top employers and find the right job opportunities effortlessly.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              "🚀 Key Features:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildFeatureItem("Smart Job Search - Find jobs that match your skills."),
            _buildFeatureItem("Bookmark Jobs - Save your favorite job listings."),
            _buildFeatureItem("Easy Applications - Apply for jobs with one tap."),
            _buildFeatureItem("Job Alerts & Notifications - Get updates instantly."),
            _buildFeatureItem("Company Reviews - Read insights from real users."),
            SizedBox(height: 20),
            Text(
              "📧 Contact Us:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("✉ Email: support@jobberapp.com"),
            Text("🌐 Website: www.jobberapp.com"),
            Text("📍 Location: Nagpur, India"),
            SizedBox(height: 20),
            Text(
              "👨‍💻 Developers:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.developer_mode, color: Colors.blueAccent, size: 24),
                SizedBox(width: 8),
                Text("Mohit Lengure", style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.developer_mode, color: Colors.blueAccent, size: 24),
                SizedBox(width: 8),
                Text("Kundan Kapgate", style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.blueAccent, size: 20),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
