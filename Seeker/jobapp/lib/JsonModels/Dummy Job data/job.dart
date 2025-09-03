import 'dart:convert';

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String address;
  final String pay;
  final List<String> jobType;
  final List<String> shift;
  final List<String> skills;
  final String description;
  final String createdAt;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.address,
    required this.pay,
    required this.jobType,
    required this.shift,
    required this.skills,
    required this.description,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? '',
      title: json['job_title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      pay: json['pay'] ?? '',
      jobType: List<String>.from(jsonDecode(json['job_type'] ?? '[]')),
      shift: List<String>.from(jsonDecode(json['shift'] ?? '[]')),
      skills: List<String>.from(jsonDecode(json['skills'] ?? '[]')),
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
