import 'package:flutter/material.dart';

class Locationscreen extends StatelessWidget {
  final String querys;

  const Locationscreen({super.key, required this.querys});

  @override
  Widget build(BuildContext context) {
    // Dummy job data (Replace with real API data)
    List<String> allJobs = [
      "Pune",
      "Nagpur",
      "Delhi",
      "Hyderabad",
      "Bengaluru",
      "Mumbai",
      "Indore",
      "Jaipur",
    ];

    // Filtering jobs based on the query
    List<String> filteredJobs =
    allJobs.where((job) => job.toLowerCase().contains(querys.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results', style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.blueAccent,
      ),
      body: filteredJobs.isEmpty
          ? Center(
        child: Text(
          'No jobs found for "$querys"',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: filteredJobs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.work, color: Colors.blueAccent),
            title: Text(filteredJobs[index]),
            onTap: () {
              // Add navigation to job details if needed
            },
          );
        },
      ),
    );
  }
}
