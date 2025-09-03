// ApplicantListScreen.dart
import 'package:flutter/material.dart';
import 'package:QuickHireRecruiter/Api/ApiService.dart';
import '../../Module/ProfileManager.dart';
import 'ApplicantDetailScreen.dart';
import '../../JsonModels/JobApplication.dart';

class ApplicantListScreen extends StatefulWidget {
  final String jobId;

  const ApplicantListScreen({super.key, required this.jobId});

  @override
  State<ApplicantListScreen> createState() => _ApplicantListScreenState();
}

class _ApplicantListScreenState extends State<ApplicantListScreen> {
  List<Map<String, dynamic>> applicants = [];
  List<Map<String, dynamic>> filteredApplicants = [];
  bool isLoading = true;
  bool hasError = false;
  String _errorMessage = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() {
      isLoading = true;
      _errorMessage = '';
    });

    try {
      // Fetch all applications from the API.
      final applicationList = await ApiService.fetchApplications(
        widget.jobId
      );

      // Filter the applications by the jobId passed to this screen.
      final jobApplications = applicationList.where((app) => app.jobId == widget.jobId).toList();

      // Convert each JobApplication to Map using toMap()
      final List<Map<String, dynamic>> applicantMaps =
      jobApplications.map((app) => app.toMap()).toList();

      setState(() {
        applicants = applicantMaps;
        filteredApplicants = applicantMaps;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _filterApplicants(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      filteredApplicants = applicants.where((applicant) {
        final name = applicant['user']?['name']?.toLowerCase() ?? '';
        final email = applicant['user']?['email']?.toLowerCase() ?? '';
        return name.contains(_searchQuery) || email.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicants for Job #${widget.jobId}'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text("Error: $_errorMessage"))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _filterApplicants,
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filteredApplicants.length,
              itemBuilder: (context, index) {
                final applicant = filteredApplicants[index];
                final user = applicant['user'] as Map<String, dynamic>?;
                final name = user?['name'] ?? 'No Name';
                final email = user?['email'] ?? 'No Email';

                return AnimatedContainer(
                  duration: Duration(milliseconds: 500 + (index * 100)),
                  curve: Curves.easeInOut,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.green.shade100,
                        child: Icon(Icons.person,
                            color: Colors.green.shade700),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      subtitle: Text(
                        email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ApplicantDetailScreen(
                                  applicant: JobApplication.fromJson(applicant),
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
