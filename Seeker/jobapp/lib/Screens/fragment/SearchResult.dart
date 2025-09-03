import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {

    // Dummy job data (Replace with real API data)
    List<String> allJobs = [
      "Software Engineer",
      "Data Analyst",
      "Flutter Developer",
      "Backend Developer",
      "UI/UX Designer",
      "Marketing Manager"
    ];

    // Filtering jobs based on the query
    List<String> filteredJobs =
    allJobs.where((job) => job.toLowerCase().contains(query.toLowerCase())).toList();

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
          'No jobs found for "$query"',
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
