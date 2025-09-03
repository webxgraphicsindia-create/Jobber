import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../Api/ApiService.dart';
import '../../constants/colors.dart';
import '../MyMainScren.dart';

class CreateJobPostScreen extends StatefulWidget {
  const CreateJobPostScreen({Key? key}) : super(key: key);

  @override
  State<CreateJobPostScreen> createState() => _CreateJobPostScreenState();
}

class _CreateJobPostScreenState extends State<CreateJobPostScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for company, salary, and description.
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

// Define controllers for each address component
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  bool _isLoading = false; // Loading state

  // Single-select dropdowns for job type and shift.
  String? _selectedJobType;
  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship'
  ];

  String? _selectedShift;
  final List<String> _shifts = ['Day shift', 'Night shift', 'Rotational'];

  // Multi-select for job titles.
  List<String> _selectedJobTitles = [];

  // Expanded list of jobs with associated skills.
  final Map<String, List<String>> _jobTitleToSkills = {
    // Information Technology & Software
    'Software Developer': ['Java', 'C#', 'Python', 'JavaScript', 'Git', 'SQL'],
    'Web Developer': [
      'HTML',
      'CSS',
      'JavaScript',
      'React',
      'Angular',
      'Node.js'
    ],
    'Full Stack Developer': [
      'JavaScript',
      'Node.js',
      'React',
      'MongoDB',
      'Express',
      'HTML',
      'CSS'
    ],
    'Backend Developer': [
      'Java',
      'Python',
      'Ruby',
      'Node.js',
      'SQL',
      'API Design'
    ],
    'Frontend Developer': [
      'HTML',
      'CSS',
      'JavaScript',
      'Angular',
      'React',
      'Vue.js'
    ],
    'Mobile App Developer': [
      'Swift',
      'Kotlin',
      'Flutter',
      'React Native',
      'Objective-C',
      'Java'
    ],
    'WordPress Developer': ['PHP', 'WordPress', 'HTML', 'CSS', 'JavaScript'],
    'Data Scientist': [
      'Python',
      'R',
      'Machine Learning',
      'Statistics',
      'Data Visualization',
      'SQL'
    ],
    'Data Analyst': ['Excel', 'SQL', 'Python', 'Power BI', 'R'],
    'DevOps Engineer': [
      'Docker',
      'Kubernetes',
      'CI/CD',
      'AWS',
      'Azure',
      'Terraform'
    ],
    'Cloud Engineer': [
      'AWS',
      'Azure',
      'Google Cloud Platform',
      'DevOps',
      'Infrastructure as Code'
    ],
    'Cybersecurity Specialist': [
      'Network Security',
      'Penetration Testing',
      'Encryption',
      'Incident Response'
    ],
    'Systems Administrator': [
      'Linux',
      'Windows Server',
      'Networking',
      'Security',
      'Active Directory'
    ],
    'Database Administrator': [
      'SQL',
      'Oracle',
      'MySQL',
      'Performance Tuning',
      'Backup and Recovery'
    ],
    'QA Engineer': [
      'Test Automation',
      'Selenium',
      'Manual Testing',
      'Bug Tracking',
      'Agile'
    ],
    'Technical Support Specialist': [
      'Troubleshooting',
      'Customer Service',
      'Hardware',
      'Software',
      'Networking'
    ],

    // Engineering & Manufacturing
    'Mechanical Engineer': [
      'CAD',
      'Thermodynamics',
      'Manufacturing Processes',
      'Project Management'
    ],
    'Electrical Engineer': [
      'Circuit Design',
      'Electronics',
      'Troubleshooting',
      'Mathematics'
    ],
    'Civil Engineer': [
      'Structural Analysis',
      'AutoCAD',
      'Project Management',
      'Building Codes'
    ],
    'Chemical Engineer': [
      'Process Engineering',
      'Chemistry',
      'Safety Procedures',
      'Process Optimization'
    ],
    'Industrial Engineer': [
      'Process Improvement',
      'Lean Manufacturing',
      'Six Sigma',
      'Quality Control'
    ],
    'Production Manager': [
      'Operations Management',
      'Quality Control',
      'Team Leadership',
      'Scheduling'
    ],
    'Factory Worker': [
      'Machine Operation',
      'Assembly',
      'Quality Control',
      'Attention to Detail'
    ],
    'Construction Worker': [
      'Manual Labor',
      'Tool Handling',
      'Safety Procedures',
      'Teamwork'
    ],
    'Mason': [
      'Bricklaying',
      'Concrete Handling',
      'Blueprint Reading',
      'Measurement'
    ],
    'Carpenter': [
      'Woodworking',
      'Tool Handling',
      'Blueprint Reading',
      'Attention to Detail'
    ],
    'Plumber': [
      'Pipe Fitting',
      'Troubleshooting',
      'Installation',
      'Safety Compliance'
    ],
    'Electrician': [
      'Wiring',
      'Circuit Analysis',
      'Maintenance',
      'Troubleshooting'
    ],
    'Painter': [
      'Surface Preparation',
      'Spraying Techniques',
      'Color Matching',
      'Attention to Detail'
    ],

    // Healthcare & Life Sciences
    'Doctor': [
      'Diagnosis',
      'Patient Care',
      'Medical Knowledge',
      'Surgery',
      'Communication'
    ],
    'Nurse': ['Patient Care', 'Medical Procedures', 'Communication', 'Empathy'],
    'Pharmacist': [
      'Medication Dispensing',
      'Pharmaceutical Knowledge',
      'Patient Counseling',
      'Inventory Management'
    ],
    'Medical Laboratory Technician': [
      'Sample Analysis',
      'Quality Control',
      'Lab Techniques',
      'Safety Procedures'
    ],
    'Dentist': ['Oral Surgery', 'Patient Care', 'Diagnosis', 'Preventive Care'],
    'Physiotherapist': [
      'Rehabilitation',
      'Manual Therapy',
      'Patient Assessment',
      'Exercise Prescription'
    ],
    'Biologist': [
      'Laboratory Techniques',
      'Research',
      'Data Analysis',
      'Scientific Writing'
    ],
    'Research Scientist': [
      'Experimental Design',
      'Data Analysis',
      'Scientific Writing',
      'Grant Writing'
    ],

    // Education & Childcare
    'Nursery Teacher': [
      'Childcare',
      'Lesson Planning',
      'Patience',
      'Child Development'
    ],
    'Primary School Teacher': [
      'Curriculum Development',
      'Classroom Management',
      'Communication',
      'Creativity'
    ],
    'High School Teacher': [
      'Subject Expertise',
      'Curriculum Development',
      'Mentoring',
      'Classroom Management'
    ],
    'College Professor': [
      'Research',
      'Curriculum Development',
      'Public Speaking',
      'Mentoring'
    ],
    'Tutor': ['Subject Expertise', 'Patience', 'Communication', 'Adaptability'],

    // Business, Finance & Administration
    'Accountant': [
      'Bookkeeping',
      'Financial Reporting',
      'Tax Preparation',
      'Auditing',
      'Excel'
    ],
    'Financial Analyst': [
      'Data Analysis',
      'Financial Modeling',
      'Forecasting',
      'Investment Analysis'
    ],
    'Business Analyst': [
      'Requirement Analysis',
      'Process Modeling',
      'Stakeholder Management',
      'Documentation'
    ],
    'Project Manager': ['Agile', 'Scrum', 'Risk Management', 'Team Leadership'],
    'Product Manager': [
      'Product Strategy',
      'Roadmapping',
      'Stakeholder Management',
      'Market Research'
    ],
    'HR Manager': [
      'Recruitment',
      'Employee Relations',
      'Performance Management',
      'Conflict Resolution'
    ],
    'Administrative Assistant': [
      'Organization',
      'Scheduling',
      'Communication',
      'Multitasking'
    ],
    'Legal Assistant': [
      'Legal Research',
      'Documentation',
      'Communication',
      'Case Management'
    ],
    'Attorney': [
      'Legal Analysis',
      'Courtroom Experience',
      'Negotiation',
      'Research'
    ],

    // Sales, Marketing & Customer Service
    'Sales Representative': [
      'Communication',
      'Negotiation',
      'CRM',
      'Customer Service'
    ],
    'Marketing Manager': [
      'SEO',
      'Social Media',
      'Analytics',
      'Campaign Management'
    ],
    'Digital Marketing Specialist': [
      'SEO',
      'Content Marketing',
      'Social Media',
      'Analytics'
    ],
    'Customer Service Representative': [
      'Communication',
      'Problem Solving',
      'Empathy',
      'Time Management'
    ],
    'Retail Salesperson': [
      'Product Knowledge',
      'Customer Service',
      'Upselling',
      'Cash Handling'
    ],
    'Business Development Manager': [
      'Networking',
      'Lead Generation',
      'Negotiation',
      'Sales Strategies'
    ],

    // Creative & Media
    'Graphic Designer': ['Photoshop', 'Illustrator', 'UI/UX', 'InDesign'],
    'UI/UX Designer': [
      'Sketch',
      'Adobe XD',
      'Figma',
      'User Research',
      'Wireframing'
    ],
    'Video Editor': [
      'Editing',
      'Final Cut Pro',
      'Adobe Premiere',
      'Creativity',
      'Storytelling'
    ],
    'Photographer': [
      'Photography',
      'Editing',
      'Lighting',
      'Creativity',
      'Attention to Detail'
    ],
    'Journalist': ['Writing', 'Research', 'Interviewing', 'Critical Thinking'],
    'Content Writer': ['Copywriting', 'SEO', 'Blogging', 'Editing', 'Research'],

    // Hospitality, Retail & Service
    'Chef': [
      'Cooking Techniques',
      'Food Safety',
      'Menu Planning',
      'Team Management'
    ],
    'Hotel Manager': [
      'Operations Management',
      'Customer Service',
      'Budgeting',
      'Team Leadership'
    ],
    'Waiter/Waitress': [
      'Customer Service',
      'Communication',
      'Time Management',
      'Multitasking'
    ],
    'Retail Manager': [
      'Inventory Management',
      'Team Leadership',
      'Customer Service',
      'Budgeting'
    ],
    'Janitor': [
      'Cleaning Techniques',
      'Maintenance',
      'Safety Procedures',
      'Attention to Detail'
    ],
    'Security Guard': [
      'Surveillance',
      'Emergency Response',
      'Observation',
      'Report Writing'
    ],

    // Transportation & Logistics
    'Driver': [
      'Safe Driving',
      'Route Planning',
      'Time Management',
      'Vehicle Maintenance'
    ],
    'Logistics Manager': [
      'Supply Chain Management',
      'Inventory Control',
      'Problem Solving',
      'Communication'
    ],
    'Warehouse Worker': [
      'Inventory Management',
      'Forklift Operation',
      'Time Management',
      'Attention to Detail'
    ],

    // Labor & Blue Collar
    'Construction Worker': [
      'Manual Labor',
      'Tool Handling',
      'Safety Procedures',
      'Teamwork'
    ],
    'Factory Worker': [
      'Machine Operation',
      'Assembly',
      'Quality Control',
      'Attention to Detail'
    ],
    'Mason': [
      'Bricklaying',
      'Concrete Handling',
      'Blueprint Reading',
      'Manual Dexterity'
    ],
    'Carpenter': [
      'Woodworking',
      'Blueprint Reading',
      'Tool Handling',
      'Precision'
    ],
    'Plumber': [
      'Pipe Fitting',
      'Installation',
      'Troubleshooting',
      'Safety Compliance'
    ],
    'Electrician': [
      'Wiring',
      'Circuit Analysis',
      'Maintenance',
      'Safety Procedures'
    ],
    'Painter': ['Surface Preparation', 'Color Matching', 'Detailing', 'Safety'],

    // Government & Public Service
    'Police Officer': [
      'Law Enforcement',
      'Investigation',
      'Communication',
      'Physical Fitness'
    ],
    'Firefighter': [
      'Emergency Response',
      'Physical Fitness',
      'Teamwork',
      'Safety Procedures'
    ],
    'Paramedic': [
      'Emergency Care',
      'CPR',
      'Quick Decision Making',
      'Patient Care'
    ],

    // Other / Miscellaneous
    'Chemist': [
      'Chemical Analysis',
      'Laboratory Techniques',
      'Safety Procedures',
      'Research'
    ],
    'Pharmacist': [
      'Medication Dispensing',
      'Patient Counseling',
      'Inventory Management',
      'Regulatory Compliance'
    ],
    'Engineer': [
      'Technical Design',
      'Problem Solving',
      'Project Management',
      'CAD'
    ],
    'Retail Manager': [
      'Customer Service',
      'Sales Strategies',
      'Team Management',
      'Inventory Control'
    ],
  };

  // Multi-select for skills.
  List<String> _selectedSkills = [];

  // Single-select for location (searchable).
  String? _selectedLocation;
  final List<String> _locations = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Pune',
    'Jaipur',
    'Lucknow',
    'Surat',
    'Nagpur',
    'Ahmedabad',
    // Add more cities as needed.
  ];

  // This getter combines skills from all selected job titles.
  List<String> get _skillsForSelectedJobTitles {
    final Set<String> skillsSet = {};
    for (var job in _selectedJobTitles) {
      skillsSet.addAll(_jobTitleToSkills[job] ?? []);
    }
    return skillsSet.toList();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _salaryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitJobPost() async {
    // Validate that multi-select dropdowns have at least one selection.
    if (_selectedJobTitles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one job title")),
      );
      return;
    }

    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one skill")),
      );
      return;
    }

    if (_selectedLocation == null || _selectedLocation!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final job_title = _selectedJobTitles.join(', ');
      final company = _companyController.text;
      final location = _selectedLocation!;
      final String streetAddress = _streetController.text;
      final String city = _cityController.text;
      final String state = _stateController.text;
      final String postalCode = _postalCodeController.text;
      final String phone = _phoneController.text.trim(); // ✅ as String
      final String pay = _salaryController.text; // ✅ renamed from salary
      final List<String> job_type =
          _selectedJobType != null ? [_selectedJobType!] : [];
      final List<String> shift =
          _selectedShift != null ? [_selectedShift!] : [];
      final String description = _descriptionController.text;
      final List<String> skills = _selectedSkills;

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await ApiService.postJob(
          job_title,
          company,
          location,
          streetAddress,
          city,
          state,
          postalCode,
          pay,
          phone,
          job_type,
          shift,
          description,
          skills,
        );

        if (response["status"] == true) {
          print("✅ Job Submitted Successfully: ${response["message"]}");
          await Future.delayed(const Duration(seconds: 2));
          _clearForm();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Job Submitted Successfully!")),
          );
        } else {
          print("❌ Job Submission Failed: ${response["error"]}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["error"])),
          );
        }

        print("job_title: $job_title");
        print("company: $company");
        print("location: $location");
        print("pay: $pay");
        print("address: $streetAddress, $city, $state - $postalCode");
        print("phone: $phone");
        print("job_type: $job_type");
        print("shift: $shift");
        print("description: $description");
        print("skills: $skills");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit job: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _companyController.clear();
    _salaryController.clear();
    _descriptionController.clear();
    _streetController.clear();
    _cityController.clear();
    _stateController.clear();
    _postalCodeController.clear();
    _phoneController.clear();

    setState(() {
      _selectedJobTitles = [];
      _selectedSkills = [];
      _selectedJobType = null;
      _selectedShift = null;
      _selectedLocation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build MultiSelectItems for job titles and skills.
    final jobTitleItems = _jobTitleToSkills.keys
        .map((job) => MultiSelectItem<String>(job, job))
        .toList();
    final skillItems = _skillsForSelectedJobTitles
        .map((skill) => MultiSelectItem<String>(skill, skill))
        .toList();

    final locationItems =
        _locations.map((city) => MultiSelectItem<String>(city, city)).toList();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyMainScreen()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.green.shade50,
        appBar: AppBar(
          title: const Text('Create Job Post'),
          backgroundColor: AppColors.customGreen,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyMainScreen()));
            },
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.customGreen, Colors.green.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.work_outline, color: Colors.white, size: 60),
                      SizedBox(height: 8),
                      Text(
                        'Post a New Job',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Fill out the details below to create your job post',
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    shadowColor: Colors.greenAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Multi-select for Job Titles.
                            /*    MultiSelectDialogField(
                            items: jobTitleItems,
                            title: const Text("Job Titles"),
                            buttonText: const Text("Select Job Titles"),
                            searchable: true,
                            listType: MultiSelectListType.LIST,
                            onConfirm: (results) {
                              setState(() {
                                _selectedJobTitles = results.cast<String>();
                                // Reset skills when job titles change.
                                _selectedSkills = [];
                              });
                            },
                            validator: (values) {
                              if (values == null || values.isEmpty) {
                                return "Please select at least one job title";
                              }
                              return null;
                            },
                          ),*/

                            MultiSelectDialogField(
                              items: jobTitleItems,
                              title: const Text("Job Titles"),
                              buttonText: const Text("Select Job Titles"),
                              searchable: true,
                              listType: MultiSelectListType.LIST,
                              // Set dialogHeight to a fraction of screen height (or leave it null if supported)
                              dialogHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                              dialogWidth:
                                  MediaQuery.of(context).size.width * 1,
                              onConfirm: (results) {
                                setState(() {
                                  _selectedJobTitles = results.cast<String>();
                                  _selectedSkills = [];
                                });
                              },
                              chipDisplay: MultiSelectChipDisplay(
                                chipColor: Colors.green.shade100,
                                textStyle:
                                    TextStyle(color: Colors.green.shade800),
                              ),
                              validator: (values) {
                                if (values == null || values.isEmpty) {
                                  return "Please select at least one job title";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),
                            // Company Name TextField.
                            _buildTextField(
                                _companyController,
                                'Company Name',
                                Icons.business,
                                'Please enter the company name'),
                            const SizedBox(height: 16),
                            // Location dropdown with search.
                            MultiSelectDialogField(
                              items: locationItems,
                              title: const Text("Location"),
                              buttonText: const Text("Select Location"),
                              searchable: true,
                              listType: MultiSelectListType.LIST,
                              initialValue: _selectedLocation != null
                                  ? [_selectedLocation!]
                                  : [],
                              onConfirm: (results) {
                                setState(() {
                                  _selectedLocation =
                                      results.isNotEmpty ? results.first : null;
                                });
                              },
                              validator: (values) {
                                if (values == null || values.isEmpty) {
                                  return "Please select a location";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),
                            Column(
                              children: [
                                TextFormField(
                                  controller: _streetController,
                                  decoration: InputDecoration(
                                    labelText: 'Street Address',
                                    prefixIcon: Icon(Icons.home),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the street address';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: _cityController,
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    prefixIcon: Icon(Icons.location_city),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the city';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: _stateController,
                                  decoration: InputDecoration(
                                    labelText: 'State',
                                    prefixIcon: Icon(Icons.map),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the state';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: _postalCodeController,
                                  decoration: InputDecoration(
                                    labelText: 'Postal Code',
                                    prefixIcon: Icon(Icons.local_post_office),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the postal code';
                                    }
                                    return null;
                                  },
                                ),
                                // Add other form fields or submission button here
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Salary TextField with rupee icon.
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                                  return 'Enter a valid 10-digit Indian phone number';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),
                            // Salary TextField with rupee icon.
                            _buildTextField(_salaryController, 'Salary',
                                Icons.currency_rupee, 'Please enter the salary',
                                inputType: TextInputType.number),
                            const SizedBox(height: 16),
                            // Job Type Dropdown.
                            _buildDropdown('Job Type', Icons.work, _jobTypes,
                                _selectedJobType, (value) {
                              setState(() {
                                _selectedJobType = value;
                              });
                            }),
                            const SizedBox(height: 16),
                            // Shift Dropdown.
                            _buildDropdown('Shift', Icons.schedule, _shifts,
                                _selectedShift, (value) {
                              setState(() {
                                _selectedShift = value;
                              });
                            }),
                            const SizedBox(height: 16),
                            // Multi-select for Skills.
                            MultiSelectDialogField(
                              items: skillItems,
                              title: const Text("Skills"),
                              buttonText: const Text("Select Skills"),
                              searchable: true,
                              listType: MultiSelectListType.LIST,
                              // Set dialogHeight to a fraction of screen height (or leave it null if supported)
                              dialogHeight:
                                  MediaQuery.of(context).size.height * 0.4,
                              dialogWidth:
                                  MediaQuery.of(context).size.width * 1,
                              onConfirm: (results) {
                                setState(() {
                                  _selectedSkills = results.cast<String>();
                                });
                              },
                              chipDisplay: MultiSelectChipDisplay(
                                chipColor: Colors.green.shade100,
                                textStyle:
                                    TextStyle(color: Colors.green.shade800),
                              ),
                              validator: (values) {
                                if (values == null || values.isEmpty) {
                                  return "Please select at least one skill";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Job Description.
                            _buildTextField(
                                _descriptionController,
                                'Job Description',
                                Icons.description,
                                'Please enter the job description',
                                maxLines: 4),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _submitJobPost,
                                icon: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Icon(Icons.send),
                                label: _isLoading
                                    ? const Text('Posting...',
                                        style: TextStyle(fontSize: 18))
                                    : const Text('Post Job',
                                        style: TextStyle(fontSize: 18)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.customGreen,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Standard text field builder.
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, String? validationMessage,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (validationMessage != null && (value == null || value.isEmpty)) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  // Standard dropdown builder.
  Widget _buildDropdown(String label, IconData icon, List<String> items,
      String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: selectedValue,
      items: items.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: items.isNotEmpty ? onChanged : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label'.toLowerCase();
        }
        return null;
      },
    );
  }
}
