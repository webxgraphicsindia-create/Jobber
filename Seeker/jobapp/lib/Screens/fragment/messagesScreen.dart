import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessageScreen> {
  String selectedScreen = "Inbox"; // Default screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200, // Light background
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green.shade100,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: Colors.green, size: 10),
              SizedBox(width: 5),
              Text(
                "Online status: On",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Dropdown Menu
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedScreen,
                  items: ["Inbox", "Sent", "Archived"]
                      .map((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedScreen = newValue!;
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                ),
              ),
            ),
          ),

          // Dynamic Screen Changes
          Expanded(
            child: selectedScreen == "Inbox"
                ? MessagesList(messages: inboxMessages)
                : selectedScreen == "Sent"
                ? MessagesList(messages: sentMessages)
                : MessagesList(messages: archivedMessages),
          ),
        ],
      ),
    );
  }
}

// Widget to Display Messages List
class MessagesList extends StatelessWidget {
  final List<Map<String, String>> messages;
  const MessagesList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return messages.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mail_outline, size: 60, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            "No messages yet!",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    )
        : ListView.builder(
      itemCount: messages.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.apartment, color: Colors.blue.shade700),
            ),
            title: Text(
              messages[index]["title"]!,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
            subtitle: Text(
              messages[index]["subtitle"]!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            trailing: Text(
              messages[index]["date"]!,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        );
      },
    );
  }
}

// Dummy Messages Data
List<Map<String, String>> inboxMessages = [
  {
    "title": "Trucksvilla Logistics",
    "subtitle": "Dear Hiring Manager, I hope this ...",
    "date": "31 Jan"
  },
  {
    "title": "Kartik Engitech Service Pvt Ltd",
    "subtitle": "Dear Hiring Manager, I hope this ...",
    "date": "3 Jan"
  },
];

List<Map<String, String>> sentMessages = [
  {
    "title": "Sent Message 1",
    "subtitle": "This is a sent message ...",
    "date": "15 Jan"
  },
  {
    "title": "Sent Message 2",
    "subtitle": "Another sent message ...",
    "date": "5 Jan"
  },
];

List<Map<String, String>> archivedMessages = [
  {
    "title": "Archived Message 1",
    "subtitle": "This is an archived message ...",
    "date": "10 Dec"
  },
  {
    "title": "Archived Message 2",
    "subtitle": "Another archived message ...",
    "date": "1 Dec"
  },
];

/*class _MessagesScreenState extends State<MessageScreen> {
  String selectedScreen = "Inbox"; // Default screen

  final List<Map<String, String>> messages = [
    {
      "title": "Blue Vision",
      "subtitle": "Dear Hiring Manager, I hope this ...",
      "date": "31 Jan"
    },
    {
      "title": "Gray Cells Web",
      "subtitle": "Dear Hiring Manager, I hope this ...",
      "date": "3 Jan"
    }, *//*  {"title": "Associative", "subtitle": "Sorry, mam but I want Internship ...", "date": "31 Dec 2024"},
    {"title": "Associative", "subtitle": "Dear Candidate, We are pleased ...", "date": "31 Dec 2024"},*//*
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            // Green outline
            borderRadius: BorderRadius.circular(6),
            color: Colors.white, // Background color (can be transparent)
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, color: Colors.green, size: 10),
              SizedBox(width: 5),
              Text(
                "Online status: On",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [],
      ),
      body: Column(
        children: [
          *//* Container(
            padding: const EdgeInsets.all(10),
            color: Colors.green.shade100,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.green, size: 10),
                SizedBox(width: 5),
                Text("Online status: On", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),*//*
          // Dropdown Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedScreen,
                  items: ["Inbox", "Sent", "Archived"]
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedScreen = newValue!;
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                ),
              ),
            ),
          ),

          // Dynamic Screen Changes
          Expanded(
            child: selectedScreen == "Inbox"
                ? MessagesList(messages: inboxMessages)
                : selectedScreen == "Sent"
                    ? MessagesList(messages: sentMessages)
                    : MessagesList(messages: archivedMessages),
          ),
        ],
      ),
    );
  }
}

// Widget to Display Messages List
class MessagesList extends StatelessWidget {
  final List<Map<String, String>> messages;
  const MessagesList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.apartment, color: Colors.blue),
          title: Text(messages[index]["title"]!,
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(messages[index]["subtitle"]!),
          trailing: Text(messages[index]["date"]!),
        );
      },
    );
  }
}

// Dummy Messages Data
List<Map<String, String>> inboxMessages = [
  {
    "title": "Trucksvilla Logistics",
    "subtitle": "Dear Hiring Manager, I hope this ...",
    "date": "31 Jan"
  },
  {
    "title": "Kartik Engitech Service Pvt Ltd",
    "subtitle": "Dear Hiring Manager, I hope this ...",
    "date": "3 Jan"
  },
];

List<Map<String, String>> sentMessages = [
  {
    "title": "Sent Message 1",
    "subtitle": "This is a sent message ...",
    "date": "15 Jan"
  },
  {
    "title": "Sent Message 2",
    "subtitle": "Another sent message ...",
    "date": "5 Jan"
  },
];

List<Map<String, String>> archivedMessages = [
  {
    "title": "Archived Message 1",
    "subtitle": "This is an archived message ...",
    "date": "10 Dec"
  },
  {
    "title": "Archived Message 2",
    "subtitle": "Another archived message ...",
    "date": "1 Dec"
  },
];*/
