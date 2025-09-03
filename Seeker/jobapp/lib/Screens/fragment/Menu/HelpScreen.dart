import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help & FAQ"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: [
                  _buildFaqItem("How do I apply for a job?",
                      "You can apply by clicking the 'Apply' button on the job listing."),
                  _buildFaqItem("How do I save a job?",
                      "Click the bookmark icon to save jobs for later."),
                  _buildFaqItem("How do I edit my profile?",
                      "Go to your profile page and click 'Edit' to update details."),
                  _buildFaqItem("How do I reset my password?",
                      "You can reset your password from the login screen by selecting 'Forgot Password'."),
                  _buildFaqItem("Is my data safe?",
                      "Yes, we ensure strict data privacy and security measures."),
                ],
              ),
            ),

            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  _askQuestion(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Ask a Question", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for FAQ items
  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ExpansionTile(
        title: Text(question, style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(answer, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // Show dialog for user question input
  void _askQuestion(BuildContext context) {
    TextEditingController _questionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ask a Question"),
          content: TextField(
            controller: _questionController,
            decoration: InputDecoration(hintText: "Type your question here"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Handle question submission (API or local storage)
                String userQuestion = _questionController.text;
                if (userQuestion.isNotEmpty) {
                  // You can send this to your database or support system
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Your question has been submitted!")),
                  );
                }
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
