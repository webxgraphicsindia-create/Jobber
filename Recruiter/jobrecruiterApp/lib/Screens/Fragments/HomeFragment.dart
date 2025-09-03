import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:QuickHireRecruiter/constants/colors.dart';
import '../../Api/ApiService.dart';
import '../../Module/ProfileManager.dart';
import 'CreateJobPostScreen.dart';
import 'JobDetailScreen.dart';


class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<Map<String, dynamic>> _jobList = [];
  List<Map<String, dynamic>> _filteredJobList = [];
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadJobs();
   _loadJobsAndApplications();
  }

  int _activeJobsCount = 0;
  int _ApplicationJobsCount = 0;

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<Map<String, dynamic>> jobs = await ApiService.fetchJobsFromApi();

      jobs.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));

      setState(() {
        _jobList = jobs;
        _filteredJobList = jobs;
        _activeJobsCount = jobs.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadJobsAndApplications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Fetch job posts from the API
      List<Map<String, dynamic>> jobs = await ApiService.fetchJobsFromApi();
      jobs.sort((a, b) =>
          DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));

      // Fetch all job applications using your API method
      final applications = await ApiService.fetchApplications(
        ProfileManager.userId,
      );

      setState(() {
        _jobList = jobs;
        _filteredJobList = jobs;
        _activeJobsCount = jobs.length;
        _ApplicationJobsCount = applications.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildMetricCard(String title, String count) {
    return Expanded(
      child: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _parseList(String? listString) {
    if (listString == null || listString.isEmpty) return '';
    try {
      List<dynamic> parsedList = List<String>.from(jsonDecode(listString));
      return parsedList.join(', ');
    } catch (_) {
      return listString;
    }
  }

  Widget _buildJobPostCard(Map<String, dynamic> jobData) {
    return FadeInRight(
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobData['job_title'] ?? '',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                jobData['company'] ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                jobData['location'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₹${jobData['pay']}', style: const TextStyle(fontSize: 14)),
                  Text(
                    _parseList(jobData['job_type']),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Posted on: ${_formatDate(jobData['created_at'])}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, Recruiter!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ready to find the perfect candidate today?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateJobPostScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Create New Job Post'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.customGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildMetricCard('Active Jobs', '$_activeJobsCount'),
                const SizedBox(width: 8),
                _buildMetricCard('New Application', '$_ApplicationJobsCount'),
                const SizedBox(width: 8),
                _buildMetricCard('Interviews', '3'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Recent Job Posts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredJobList.isEmpty
                ? const Text('No job posts found.')
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredJobList.length,
              itemBuilder: (context, index) {
                final jobData = _filteredJobList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailScreen(jobData: jobData),
                      ),
                    );
                  },
                  child: _buildJobPostCard(jobData),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
