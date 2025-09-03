import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  final List<Map<String, String>> messages = [
    {
      'jobTitle': 'Flutter Developer',
      'jobSeeker': 'Alice Johnson',
      'lastMessage': 'I have submitted my resume.',
    },
    {
      'jobTitle': 'UI/UX Designer',
      'jobSeeker': 'Bob Smith',
      'lastMessage': 'When is the interview?',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            leading: const Icon(Icons.work_outline),
            title: Text(message['jobSeeker']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From Job: ${message['jobTitle']}'),
                const SizedBox(height: 4),
                Text(message['lastMessage']!, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            onTap: () {
              // Navigate to chat screen
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChatScreen(
                  jobTitle: message['jobTitle']!,
                  jobSeeker: message['jobSeeker']!,
                ),
              ));
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String jobTitle;
  final String jobSeeker;

  const ChatScreen({Key? key, required this.jobTitle, required this.jobSeeker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$jobSeeker - $jobTitle'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Chat screen coming soon...'),
      ),
    );
  }
}
