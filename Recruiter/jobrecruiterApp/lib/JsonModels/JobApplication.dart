import 'dart:convert';

import 'package:QuickHireRecruiter/JsonModels/user.dart';

class JobApplication {
  final String id;
  final String jobId;
  final String userId;
  final List<String> skills;
  final String? resume;
  final String status;
  final DateTime createdAt;
  final User user;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.skills,
    required this.resume,
    required this.status,
    required this.createdAt,
    required this.user,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    // Handle skills parsing - it might come as a List or a JSON string
    List<String> skillsList = [];

    if (json['skills'] is List) {
      // If skills is already a List, use it directly
      skillsList = List<String>.from(json['skills']);
    } else if (json['skills'] is String) {
      try {
        // Try to parse the string as JSON
        final parsed = jsonDecode(json['skills'] as String);
        if (parsed is List) {
          skillsList = List<String>.from(parsed);
        } else if (parsed is String) {
          // Handle case where it's a comma-separated string inside JSON string
          skillsList = parsed.split(',').map((s) => s.trim()).toList();
        }
      } catch (e) {
        // Fallback to treating as comma-separated string
        skillsList = (json['skills'] as String)
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }
    }

    return JobApplication(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      userId: json['user_id'] as String,
      skills: skillsList,
      resume: json['resume'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : User(id: '', name: 'Unknown', email: ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'job_id': jobId,
      'user_id': userId,
      'skills': skills,
      'resume': resume,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'user': {
        'id': user.id,
        'name': user.name,
        'email': user.email,
      },
    };
  }
}