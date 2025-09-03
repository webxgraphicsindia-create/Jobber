import 'dart:convert';
import 'dart:io';
import 'package:QuickHire/Screens/API/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../JsonModels/ProfileManager.dart';
import 'PdfPreviewScreen.dart';

class ApplyScreen extends StatefulWidget {
  final String jobId;
  final List<String> selectedSkills;

  const ApplyScreen({Key? key, required this.jobId, required this.selectedSkills}) : super(key: key);

  @override
  _ApplyScreenState createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  File? _resumeFile;
  bool _isUploading = false;
  String _uploadStatus = '';
  bool _hasApplied = false; // Flag to indicate if user has applied

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _checkAppliedStatus();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Check if the user already applied for this job (using SharedPreferences)
  Future<void> _checkAppliedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('applied_job_ids');
    List<String> appliedJobIds = [];
    if (jsonString != null) {
      appliedJobIds = List<String>.from(jsonDecode(jsonString));
    }
    setState(() {
      _hasApplied = appliedJobIds.contains(widget.jobId);
    });
  }

  // Save current jobId to applied list in SharedPreferences
  Future<void> _saveAppliedJobId(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('applied_job_ids');
    List<String> appliedJobIds = [];
    if (jsonString != null) {
      appliedJobIds = List<String>.from(jsonDecode(jsonString));
    }
    if (!appliedJobIds.contains(jobId)) {
      appliedJobIds.add(jobId);
      await prefs.setString('applied_job_ids', jsonEncode(appliedJobIds));
    }
  }

  Future<void> _pickResume() async {
    if (_hasApplied) return; // Prevent resume selection if already applied
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _resumeFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitApplication() async {
    if (_hasApplied) {
      setState(() {
        _uploadStatus = 'You have already applied for this job.';
      });
      return;
    }
    if (_resumeFile == null) {
      setState(() {
        _uploadStatus = 'Please select a resume file.';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadStatus = 'Submitting...';
    });

    try {
      final message = await ApiService.applyJobApi(
        jobId: widget.jobId,
        resumeFile: _resumeFile!,
        selectedSkills: widget.selectedSkills,
      );

      setState(() {
        _uploadStatus = message;
      });

      // If successful, mark as applied
      if (message.toLowerCase().contains("success")) {
        await _saveAppliedJobId(widget.jobId);
        setState(() {
          _hasApplied = true;
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = e.toString();
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  bool get _isPdfSelected {
    if (_resumeFile == null) return false;
    return _resumeFile!.path.toLowerCase().endsWith('.pdf');
  }

  void _showPdfModal(BuildContext context) {
    if (_resumeFile == null || !_isPdfSelected) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.95,
        initialChildSize: 0.9,
        builder: (_, controller) => ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Preview Resume"),
              backgroundColor: Colors.blueAccent,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: PdfPreviewScreen(filePath: _resumeFile!.path),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for Job"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Selected Skills",
                    style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: widget.selectedSkills
                        .map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: Colors.blue.shade100,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 30),
                  _resumeFile == null
                      ? GestureDetector(
                    onTap: _pickResume,
                    child: Column(
                      children: [
                        Icon(Icons.insert_drive_file,
                            size: 80, color: Colors.grey[400]),
                        SizedBox(height: 10),
                        Text(
                          "No Resume Selected\nTap to Upload",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      ],
                    ),
                  )
                      : Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(
                        _isPdfSelected
                            ? Icons.picture_as_pdf
                            : Icons.insert_drive_file,
                        color: _isPdfSelected
                            ? Colors.redAccent
                            : Colors.blueAccent,
                        size: 40,
                      ),
                      title: Text(
                        basename(_resumeFile!.path),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: TextButton.icon(
                        onPressed: () => _showPdfModal(context),
                        icon: Icon(Icons.visibility),
                        label: Text("Preview"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _hasApplied ? null : _pickResume,
                    icon: Icon(Icons.upload_file),
                    label: Text("Select Resume"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasApplied ? Colors.grey : Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _isUploading
                      ? CircularProgressIndicator()
                      : ElevatedButton.icon(
                    onPressed: _hasApplied ? null : _submitApplication,
                    icon: Icon(Icons.send),
                    label: Text(_hasApplied ? "Already Applied" : "Submit Application"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasApplied ? Colors.grey : Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _uploadStatus,
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
