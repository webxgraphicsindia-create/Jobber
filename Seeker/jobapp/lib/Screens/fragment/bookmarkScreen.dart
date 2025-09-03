import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:QuickHire/Screens/fragment/JobDetailsScreen.dart';
import 'package:QuickHire/JsonModels/BookmarkNotifier.dart';
import 'package:QuickHire/JsonModels/Dummy Job data/job.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../API/ApiService.dart';

class bookmarkScreen extends StatefulWidget {
  @override
  _bookmarkScreenState createState() => _bookmarkScreenState();
}

class _bookmarkScreenState extends State<bookmarkScreen>
    with TickerProviderStateMixin {
  List<Job> allJobs = [];
  List<String> appliedJobIds = [];
  bool _isLoading = true;
  String _errorMessage = '';

  late TabController _tabController;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadJobs();
    _loadAppliedJobIds();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      List<Map<String, dynamic>> jobsData = await ApiService.fetchJobsFromApi();
      List<Job> jobModels =
          jobsData.map((jobMap) => Job.fromJson(jobMap)).toList();
      setState(() {
        allJobs = jobModels;
        _isLoading = false;
      });
      _controller.forward();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAppliedJobIds() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('applied_job_ids');
    if (jsonString != null) {
      setState(() {
        appliedJobIds = List<String>.from(jsonDecode(jsonString));
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Jobs" , style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                s.bookmarkedJobs,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                "Applied Jobs",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text("Error: $_errorMessage"))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildJobList(
                      title: s.noBookmarkedJobs,
                      filter: (job) => context
                          .read<BookmarkNotifier>()
                          .bookmarkedJobs
                          .contains(job.id.toString()),
                      isBookmarkList: true,
                    ),
                    _buildJobList(
                      title: "You haven’t applied to any jobs yet.",
                      filter: (job) =>
                          appliedJobIds.contains(job.id.toString()),
                      isBookmarkList: false,
                    ),
                  ],
                ),
    );
  }

  Widget _buildJobList({
    required String title,
    required bool Function(Job) filter,
    required bool isBookmarkList,
  }) {
    return Consumer<BookmarkNotifier>(
      builder: (context, bookmarkNotifier, child) {
        final filteredJobs = allJobs.where(filter).toList();

        if (filteredJobs.isEmpty) {
          return Center(
              child: Text(title, style: const TextStyle(fontSize: 18)));
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredJobs.length,
              itemBuilder: (context, index) {
                final job = filteredJobs[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        job.title.isNotEmpty ? job.title[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      job.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "${job.company} • ${job.location}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: isBookmarkList
                        ? IconButton(
                            icon: const Icon(Icons.bookmark_remove,
                                color: Colors.redAccent),
                            onPressed: () {
                              bookmarkNotifier
                                  .toggleBookmark(job.id.toString());
                            },
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailsScreen(job: job),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
