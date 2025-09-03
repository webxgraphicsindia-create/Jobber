import 'package:flutter/material.dart';
import 'package:QuickHire/JsonModels/Dummy%20Job%20data/job.dart';


import '../API/ApiService.dart';

class JobSearchScreen extends StatefulWidget {
  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  TextEditingController jobController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  List<Job> allJobs = [];
  bool isLoading = true;

  // We'll build suggestions based on loaded job titles and locations.
  List<String> get jobSuggestions {
    // Get unique job titles from loaded jobs.
    final titles = allJobs.map((job) => job.title).toSet().toList();
    titles.sort();
    return titles;
  }

  List<String> get locationSuggestions {
    // Get unique locations from loaded jobs.
    final locations = allJobs.map((job) => job.location).toSet().toList();
    locations.sort();
    return locations;
  }

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  /// Load jobs from API
  Future<void> _loadJobs() async {
    try {
      List<Map<String, dynamic>> jobsData = await ApiService.fetchJobsFromApi();
      // Convert each map to a Job model
      List<Job> jobModels = jobsData.map((jobMap) => Job.fromJson(jobMap)).toList();
      setState(() {
        allJobs = jobModels;
        isLoading = false;
      });
    } catch (e) {
      // Handle error appropriately in production code.
      print("Error loading jobs: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Perform search and return the entered queries
  void _searchJobs() {
    String jobTitleQuery = jobController.text.trim();
    String locationQuery = locationController.text.trim();

    // Return the search parameters to the previous screen
    Navigator.pop(context, {
      'jobTitle': jobTitleQuery,
      'location': locationQuery,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Search"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Job Title Input + Suggestions
            TextField(
              controller: jobController,
              decoration: InputDecoration(
                labelText: "Search Job Title...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() {}),
            ),
            if (jobController.text.isNotEmpty) ..._buildJobSuggestions(),

            SizedBox(height: 10),

            // Location Input + Suggestions
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Enter Location...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() {}),
            ),
            if (locationController.text.isNotEmpty) ..._buildLocationSuggestions(),

            SizedBox(height: 15),

            // Search Button
            ElevatedButton(
              onPressed: _searchJobs,
              child: Text("Search"),
            ),
          ],
        ),
      ),
    );
  }

  /// Build job title suggestions based on loaded data
  List<Widget> _buildJobSuggestions() {
    return jobSuggestions
        .where((title) => title.toLowerCase().contains(jobController.text.toLowerCase()))
        .map((suggestion) => ListTile(
      title: Text(suggestion),
      onTap: () {
        setState(() => jobController.text = suggestion);
      },
    ))
        .toList();
  }

  /// Build location suggestions based on loaded data
  List<Widget> _buildLocationSuggestions() {
    return locationSuggestions
        .where((location) => location.toLowerCase().contains(locationController.text.toLowerCase()))
        .map((suggestion) => ListTile(
      title: Text(suggestion),
      onTap: () {
        setState(() => locationController.text = suggestion);
      },
    ))
        .toList();
  }
}
