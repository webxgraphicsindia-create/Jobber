import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:QuickHire/Screens/Auth/LoginScreen.dart';
import 'package:QuickHire/Screens/fragment/JobDetailsScreen.dart';
import 'package:QuickHire/Screens/fragment/notificationScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../JsonModels/BookmarkNotifier.dart';
import '../../JsonModels/Dummy Job data/job.dart';
import '../../JsonModels/ProfileManager.dart';
import '../API/ApiService.dart';
import '../API/GoogleSignInApi.dart';
import 'SearchScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use synthetic package

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController jobSearchController = TextEditingController();
  final TextEditingController locationSearchController = TextEditingController();

  // Store the API data as a list of Job objects
  List<Job> _allJobs = [];
  List<Job> filteredJobs = [];

  bool _isLoading = true;
  String _errorMessage = '';
  String? username = ProfileManager.userName;

  bool isLoading = true; // Controls shimmer loading state

  @override
  void initState() {
    super.initState();
    _simulateLoading();
    _loadBookmarks();
    _loadJobs();
  }

  // Using ValueNotifier to hold bookmarked job IDs
  ValueNotifier<List<String>> bookmarkedJobsNotifier = ValueNotifier([]);

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      // Fetch list of job maps from your API
      List<Map<String, dynamic>> jobsData = await ApiService.fetchJobsFromApi();

      // Sort jobs by created_at in descending order
      jobsData.sort((a, b) =>
          DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));

      // Convert each map to a Job model
      List<Job> jobModels = jobsData.map((jobMap) => Job.fromJson(jobMap)).toList();

      setState(() {
        _allJobs = jobModels;
        filteredJobs = jobModels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _simulateLoading() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> __signOut() async {
    await GoogleSignInApi().signOutFromGoogle(context);
    print("User signed out");
  }

  Future<void> _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Logged out successfully!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLogin()));
  }

  void _openSearchScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobSearchScreen()),
    );
    if (result != null) {
      // Use 'jobTitle' (camelCase) because that's what JobSearchScreen returns.
      String jobTitle = result['jobTitle'] ?? '';
      String location = result['location'] ?? '';
      _applySearchFilter(jobTitle, location);
    } else {
      setState(() {
        filteredJobs = _allJobs;
      });
    }
  }

  // Basic search filter (by title and location)
  void _applySearchFilter(String jobTitle, String location) {
    setState(() {
      List<Job> tempList = _allJobs;
      if (jobTitle.trim().isNotEmpty) {
        tempList = tempList.where((job) =>
            job.title.toLowerCase().contains(jobTitle.toLowerCase())).toList();
      }
      if (location.trim().isNotEmpty) {
        tempList = tempList.where((job) =>
            job.location.toLowerCase().contains(location.toLowerCase())).toList();
      }
      filteredJobs = tempList;
    });
  }

  void _showAdvancedFilterBottomSheet() {
    List<String> selectedJobTypes = [];
    List<String> selectedShifts = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController locationController = TextEditingController();

        final List<String> jobTitleOptions = [
          "Software Developer", "Graphic Designer", "Data Analyst", "Sales Executive",
          "Content Writer", "Marketing Manager", "UI/UX Designer", "QA Tester"
        ];

        final List<String> locationOptions = [
          "Mumbai", "Delhi", "Bangalore", "Pune", "Hyderabad",
          "Chennai", "Ahmedabad", "Kolkata", "Jaipur", "Lucknow"
        ];

        final List<String> jobTypeOptions = ["Full-time", "Part-time", "Contract", "Remote"];
        final List<String> shiftOptions = ["Day", "Night", "Rotational"];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Filter Jobs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // --- Job Title ---
                    Text("Job Title", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownSearch<String>(
                      items: jobTitleOptions,
                      selectedItem: titleController.text.isNotEmpty ? titleController.text : null,
                      onChanged: (value) {
                        setModalState(() {
                          titleController.text = value ?? '';
                        });
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search Job Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Select Job Title",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Location ---
                    Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownSearch<String>(
                      items: locationOptions,
                      selectedItem: locationController.text.isNotEmpty ? locationController.text : null,
                      onChanged: (value) {
                        setModalState(() {
                          locationController.text = value ?? '';
                        });
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search Location',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Select Location",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Job Type ---
                    Text("Job Type", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: jobTypeOptions.map((option) {
                        final isSelected = selectedJobTypes.contains(option);
                        return FilterChip(
                          label: Text(option),
                          selected: isSelected,
                          selectedColor: Colors.blue.shade100,
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                selectedJobTypes.add(option);
                              } else {
                                selectedJobTypes.remove(option);
                              }
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          checkmarkColor: Colors.blue,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // --- Shift ---
                    Text("Shift", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: shiftOptions.map((option) {
                        final isSelected = selectedShifts.contains(option);
                        return FilterChip(
                          label: Text(option),
                          selected: isSelected,
                          selectedColor: Colors.green.shade100,
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                selectedShifts.add(option);
                              } else {
                                selectedShifts.remove(option);
                              }
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          checkmarkColor: Colors.green,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              titleController.clear();
                              locationController.clear();
                              selectedJobTypes.clear();
                              selectedShifts.clear();
                            });
                          },
                          child: Text("Clear Filter"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Map<String, dynamic> filters = {
                              'jobTitle': titleController.text.trim(),
                              'location': locationController.text.trim(),
                              'jobTypes': selectedJobTypes,
                              'shifts': selectedShifts,
                            };
                            Navigator.pop(context, filters);
                          },
                          child: Text("Apply Filter"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        _applyAdvancedFilter(result);
      }
    });
  }




  // Apply advanced filter based on the given map.
  void _applyAdvancedFilter(Map<String, dynamic> filters) {
    String jobTitle = filters['jobTitle'] ?? '';
    String location = filters['location'] ?? '';
    List<String> jobTypes = filters['jobTypes'] ?? [];
    List<String> shifts = filters['shifts'] ?? [];

    setState(() {
      List<Job> tempList = _allJobs;
      if (jobTitle.trim().isNotEmpty) {
        tempList = tempList.where((job) =>
            job.title.toLowerCase().contains(jobTitle.toLowerCase())).toList();
      }
      if (location.trim().isNotEmpty) {
        tempList = tempList.where((job) =>
            job.location.toLowerCase().contains(location.toLowerCase())).toList();
      }
      if (jobTypes.isNotEmpty) {
        tempList = tempList.where((job) {
          // Assuming job.jobType is a List<String>
          return job.jobType.any((type) => jobTypes.contains(type));
        }).toList();
      }
      if (shifts.isNotEmpty) {
        tempList = tempList.where((job) {
          // Assuming job.shift is a List<String>
          return job.shift.any((shift) => shifts.contains(shift));
        }).toList();
      }
      filteredJobs = tempList;
    });
  }

  Future<void> _showSignOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _signOut();
                await __signOut();
                await ProfileManager.clearProfileData();
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  // Save bookmarks to SharedPreferences
  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarked_jobs', bookmarkedJobsNotifier.value);
  }

  /// Toggle bookmark for a job
  void _toggleBookmark(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> updatedBookmarks = List.from(bookmarkedJobsNotifier.value);
    if (updatedBookmarks.contains(jobId)) {
      updatedBookmarks.remove(jobId);
    } else {
      updatedBookmarks.add(jobId);
    }
    bookmarkedJobsNotifier.value = updatedBookmarks;
    await prefs.setString('bookmarked_jobs', jsonEncode(updatedBookmarks));
  }

  void _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkListString = prefs.getString('bookmarked_jobs');
    if (bookmarkListString != null) {
      final List<String> loadedBookmarks = List<String>.from(jsonDecode(bookmarkListString));
      bookmarkedJobsNotifier.value = loadedBookmarks;
    }
  }

  // Function to calculate active days or relative time
  String _formatActiveDays(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          s.appName,
          style: TextStyle(color: Colors.blueAccent, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications, color: Colors.blueAccent, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text("3",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
              print("Notification Clicked");
            },
          ),
          SizedBox(height: 10),
          PopupMenuButton(
            offset: Offset(0, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey[300],
                      child: Text(username![0],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    Text(username!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(ProfileManager.userEmail,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    Divider(),
                  ],
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(s.logout, style: TextStyle(color: Colors.red)),
                  onTap: () {
                    _showSignOutDialog();
                  },
                ),
              )
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Text(username![0],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildClickableSearchBox(),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(s.recentJobPosts,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading || _isLoading
                    ? _buildShimmerList()
                    : _errorMessage.isNotEmpty
                    ? Center(child: Text("Error: $_errorMessage"))
                    : _buildJobList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.filter_list),
        onPressed: _showAdvancedFilterBottomSheet,
      ),
    );
  }

  Widget _buildClickableSearchBox() {
    return GestureDetector(
      onTap: () => _openSearchScreen(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text("Search for jobs...", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(5, (index) => _buildShimmerContainer(index)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerContainer(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Container(
        height: index == 4 ? 30.0 : 15.0,
        width: index == 0 ? double.infinity : [100, 150, 80, 100][index - 1].toDouble(),
        color: Colors.white,
      ),
    );
  }

  Widget _buildJobList() {
    final s = AppLocalizations.of(context)!;
    print("Building Job List with ${filteredJobs.length} items");
    return ListView.builder(
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) {
        final job = filteredJobs[index];
        print("Displaying Job: ${job.title}");
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job)),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, spreadRadius: 1, offset: Offset(2, 3)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Title and Bookmark Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        job.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ValueListenableBuilder<List<String>>(
                      valueListenable: bookmarkedJobsNotifier,
                      builder: (context, bookmarkedJobs, child) {
                        return IconButton(
                          icon: Consumer<BookmarkNotifier>(
                            builder: (context, bookmarkNotifier, child) {
                              bool isBookmarked = bookmarkNotifier.bookmarkedJobs.contains(job.id);
                              return Icon(
                                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                color: isBookmarked ? Colors.blueAccent : Colors.grey,
                              );
                            },
                          ),
                          onPressed: () {
                            Provider.of<BookmarkNotifier>(context, listen: false).toggleBookmark(job.id);
                            _toggleBookmark(job.id);
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(job.company, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 5),
                Text(job.location, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 5),
                Text('₹${job.pay}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(_formatActiveDays(job.createdAt),
                        style: TextStyle(fontSize: 14, color: Colors.green)),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job)));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: Text(s.apply, style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
