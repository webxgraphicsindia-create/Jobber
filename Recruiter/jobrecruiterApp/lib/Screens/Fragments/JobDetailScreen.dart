import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobDetailScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const JobDetailScreen({super.key, required this.jobData});

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  List<String> _parseList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    return List<String>.from(
      (raw.startsWith('[') ? raw : '["$raw"]').replaceAll(RegExp(r'[\[\]"]'), '').split(','),
    ).map((e) => e.trim()).toList();
  }

  Widget _buildInfoTile({required IconData icon, required String label, required String value}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.green.shade700),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobTypes = _parseList(jobData['job_type']);
    final shifts = _parseList(jobData['shift']);
    final skills = _parseList(jobData['skills']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: jobData['id'],
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    jobData['job_title'] ?? '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                jobData['company'] ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Posted on: ${_formatDate(jobData['created_at'])}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Divider(height: 32),

              _buildInfoTile(
                icon: Icons.location_on,
                label: 'Location',
                value: jobData['location'] ?? '',
              ),
              _buildInfoTile(
                icon: Icons.payments,
                label: 'Pay',
                value: '₹${jobData['pay']}',
              ),
              _buildInfoTile(
                icon: Icons.work_outline,
                label: 'Job Type',
                value: jobTypes.join(', '),
              ),
              _buildInfoTile(
                icon: Icons.nightlight_round,
                label: 'Shift',
                value: shifts.join(', '),
              ),

              const SizedBox(height: 16),
              const Text(
                'Required Skills',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: skills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: Colors.green.shade100,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              const Text(
                'Job Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                jobData['description'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Example: Edit or Apply
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Job'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
