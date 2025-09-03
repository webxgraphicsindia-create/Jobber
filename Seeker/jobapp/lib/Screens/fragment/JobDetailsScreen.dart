import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../JsonModels/Dummy Job data/job.dart';
import 'ApplyScreen.dart';
import 'JobDetailTile.dart';
class JobDetailsScreen extends StatefulWidget {
  final Job job;

  const JobDetailsScreen({Key? key, required this.job}) : super(key: key);

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  Set<String> selectedSkills = {};

  void toggleSkill(String skill) {
    setState(() {
      if (selectedSkills.contains(skill)) {
        selectedSkills.remove(skill);
      } else {
        selectedSkills.add(skill);
      }
    });
  }

  void applyNow() {
    if (selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one skill to apply.")),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApplyScreen(
            jobId: widget.job.id,
            selectedSkills: selectedSkills.toList(), // Send selected skills
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Job Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share job logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(job.location, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),

            // Skills Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.light_mode_outlined, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Skills", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: job.skills.map((skill) {
                          final isSelected = selectedSkills.contains(skill);
                          return FilterChip(
                            label: Text(skill),
                            selected: isSelected,
                            onSelected: (_) => toggleSkill(skill),
                            selectedColor: Colors.blue,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.blue),
                            backgroundColor: Colors.blue.shade50,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text("Job details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            JobDetailTile(icon: Icons.currency_rupee, title: "Pay", subtitle: job.pay),

            // Job Type
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.work, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Job type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: job.jobType.map((type) {
                          return ActionChip(
                            label: Text(type),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Clicked on "$type"')),
                              );
                            },
                            backgroundColor: Colors.green.shade50,
                            labelStyle: TextStyle(color: Colors.green.shade700),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Shift
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.schedule, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Shift and schedule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: job.shift.map((shift) {
                          return ActionChip(
                            label: Text(shift),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Clicked on "$shift"')),
                              );
                            },
                            backgroundColor: Colors.orange.shade50,
                            labelStyle: TextStyle(color: Colors.orange.shade700),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text("Full job description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(job.description, style: const TextStyle(fontSize: 14, color: Colors.black)),
            const SizedBox(height: 16),

            // Apply Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: applyNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Apply now", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Save Job
                    },
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text("Save job"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Report Job
                    },
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text("Report job"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
