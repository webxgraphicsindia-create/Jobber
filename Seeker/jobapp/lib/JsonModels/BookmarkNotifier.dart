import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkNotifier extends ChangeNotifier {
  List<String> _bookmarkedJobs = [];

  List<String> get bookmarkedJobs => _bookmarkedJobs;

  BookmarkNotifier() {
    _loadBookmarks(); // Load bookmarks when app starts
  }

  // Load bookmarks from SharedPreferences
  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedBookmarks = prefs.getString('bookmarked_jobs');

    if (storedBookmarks != null) {
      _bookmarkedJobs = List<String>.from(jsonDecode(storedBookmarks));
      notifyListeners(); // Notify UI when data loads
    }
  }

  // Toggle bookmark (Add or Remove) for a given jobId (String)
  Future<void> toggleBookmark(String jobId) async {
    final prefs = await SharedPreferences.getInstance();

    if (_bookmarkedJobs.contains(jobId)) {
      _bookmarkedJobs.remove(jobId); // Remove bookmark
    } else {
      _bookmarkedJobs.add(jobId); // Add bookmark
    }

    await prefs.setString('bookmarked_jobs', jsonEncode(_bookmarkedJobs));
    notifyListeners(); // Notify UI to refresh
  }

  // Remove bookmark explicitly
  Future<void> removeBookmark(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    _bookmarkedJobs.remove(jobId);
    await prefs.setString('bookmarked_jobs', jsonEncode(_bookmarkedJobs));
    notifyListeners(); // Notify UI to update
  }
}

// Create a global instance of BookmarkNotifier if needed
final bookmarkNotifier = BookmarkNotifier();
