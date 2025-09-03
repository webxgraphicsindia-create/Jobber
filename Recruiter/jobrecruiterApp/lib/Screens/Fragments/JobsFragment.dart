import 'package:flutter/material.dart';
import '../../Api/ApiService.dart';
import 'ApplicantListScreen.dart';

class JobsFragment extends StatefulWidget {
  const JobsFragment({Key? key}) : super(key: key);

  @override
  State<JobsFragment> createState() => _JobsFragmentState();
}

class _JobsFragmentState extends State<JobsFragment> {
  List<Map<String, dynamic>> _jobList = [];
  List<Map<String, dynamic>> _filteredJobList = [];
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<Map<String, dynamic>> jobs = await ApiService.fetchJobsFromApi();
      setState(() {
        _jobList = jobs;
        _filteredJobList = jobs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterJobs(String query) {
    setState(() {
      _filteredJobList = _jobList.where((job) {
        return job['job_title'].toLowerCase().contains(query.toLowerCase()) ||
            job['company'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color customGreen = const Color(0xFF4CAF50);

    return Scaffold(
      body: Container(
        color: Colors.green.shade50,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterJobs,
                decoration: InputDecoration(
                  hintText: 'Search jobs...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
            ),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_errorMessage.isNotEmpty)
              Expanded(child: Center(child: Text(_errorMessage)))
            else if (_filteredJobList.isEmpty)
                const Expanded(child: Center(child: Text('No jobs found.')))
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _filteredJobList.length,
                    itemBuilder: (context, index) {
                      final job = _filteredJobList[index];
                      final jobId = job['id']; // ✅ Get job ID

                      return GestureDetector(
                        onTap: () {
                          if (jobId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ApplicantListScreen(jobId: jobId),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid Job ID')),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['job_title'] ?? "No Title",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.business, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(job['company'] ?? "No Company",
                                        style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(job['location'] ?? "No Location",
                                        style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Chip(
                                      label: Text(job['job_type'] ?? "Type N/A"),
                                      backgroundColor: customGreen.withOpacity(0.1),
                                      labelStyle: TextStyle(color: customGreen),
                                    ),
                                    Text(
                                      job['salary'] ?? "Not Specified",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
