import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:QuickHireRecruiter/JsonModels/user.dart';
import '../../Api/ApiService.dart';
import '../../JsonModels/JobApplication.dart';


class ApplicantDetailScreen extends StatelessWidget {
  final JobApplication applicant;

  const ApplicantDetailScreen({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    final name = applicant.user.name;
    final email = applicant.user.email;

    // Construct the resume URL using the API endpoint
    final resumeUrl = applicant.id.isNotEmpty
        ? 'https://jobber.riverstonehydration.com/api/admin/employer/application/resume/${applicant.id}'
        : null;

    // Debug print to check URL
    print("Loading resume from: $resumeUrl");

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: $name", style: const TextStyle(fontSize: 18)),
            Text("Email: $email", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            if (resumeUrl != null)
              FutureBuilder<String?>(
                future: ApiService.getToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Text("Failed to load authentication token");
                  }

                  final token = snapshot.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Resume:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        height: 500,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SfPdfViewer.network(
                          resumeUrl,
                          headers: {
                            'Authorization': 'Bearer $token',
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
            else
              const Text("No resume available"),
          ],
        ),
      ),
    );
  }
}