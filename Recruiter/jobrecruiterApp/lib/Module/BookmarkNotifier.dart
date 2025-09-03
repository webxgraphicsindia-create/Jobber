import 'package:flutter/material.dart';

class BookmarkNotifier extends ChangeNotifier {
  final List<String> _bookmarkedJobs = [];
  final List<String> _appliedJobs = [];

  List<String> get bookmarkedJobs => _bookmarkedJobs;
  List<String> get appliedJobs => _appliedJobs;

  void toggleBookmark(String jobId) {
    if (_bookmarkedJobs.contains(jobId)) {
      _bookmarkedJobs.remove(jobId);
    } else {
      _bookmarkedJobs.add(jobId);
    }
    notifyListeners();
  }

  void markAsApplied(String jobId) {
    if (!_appliedJobs.contains(jobId)) {
      _appliedJobs.add(jobId);
      notifyListeners();
    }
  }

  void removeApplied(String jobId) {
    if (_appliedJobs.contains(jobId)) {
      _appliedJobs.remove(jobId);
      notifyListeners();
    }
  }

  void clearAll() {
    _bookmarkedJobs.clear();
    _appliedJobs.clear();
    notifyListeners();
  }
}
