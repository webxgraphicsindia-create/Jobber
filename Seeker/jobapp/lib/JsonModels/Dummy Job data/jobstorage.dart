/*
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'job.dart';

class JobStorage {
  static const String _jobsKey = "jobs_list";

  /// Save job list to shared preferences
  static Future<void> saveJobs(List<Job> jobs) async {
    final prefs = await SharedPreferences.getInstance();
    final jobListJson = jobs.map((job) => job.toJson()).toList();
    prefs.setString(_jobsKey, jsonEncode(jobListJson));
  }

  /// Retrieve job list from shared preferences
  static Future<List<Job>> getJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final jobListString = prefs.getString(_jobsKey);

    if (jobListString == null) {
      return generateDummyJobs(); // Return dummy data if no saved jobs exist
    }

    final List<dynamic> jobListJson = jsonDecode(jobListString);
    return jobListJson.map((json) => Job.fromJson(json)).toList();
  }

  /// Generate some dummy job listings
  /// Generate some dummy job listings
  static List<Job> generateDummyJobs() {
    return [
      Job(
        id: 1,
        title: "Android Developer",
        company: "Tech Solutions",
        location: "Pune, India",
        salary: "₹50,000 - ₹70,000 per month",
        jobType: "Full-time",
        shift: "Day shift",
        description: "We are looking for an Android Developer with expertise in Kotlin and Jetpack Compose.",
        //active: "Active 1 day ago.",
        skills: ["Flutter", "Kotlin", "Dart", "Jetpack Compose", "Firebase", "REST APIs", "MVVM architecture"],
       // actives: "Active 1 day ago", // ✅ Added
      ),
      Job(
        id: 2,
        title: "Flutter Developer",
        company: "Code Innovators",
        location: "Remote",
        salary: "₹40,000 - ₹60,000 per month",
        jobType: "Remote",
        shift: "Flexible",
        description: "We are hiring a Flutter Developer with experience in building cross-platform mobile applications.",
        //active: "Active 1 day ago.",
        skills: ["Dart", "Flutter", "Firebase", "REST APIs", "MVVM architecture"],
        //actives: "Active 2 days ago", // ✅ Added
      ),
      Job(
        id: 3,
        title: "Backend Developer",
        company: "Cloud Softwares",
        location: "Bangalore, India",
        salary: "₹60,000 - ₹90,000 per month",
        jobType: "Full-time",
        shift: "Day shift",
        description: "Seeking an experienced backend developer proficient in Node.js, Laravel, and database management.",
        //active: "Active 1 day ago.",
        skills: ["Laravel", "PHP", "Hosting", "MySQL", "API"],
        //actives: "Active 4 days ago", // ✅ Added
      ),
      Job(
        id: 4,
        title: "Full-Stack Engineer",
        company: "NextGen Technologies",
        location: "Mumbai, India",
        salary: "₹75,000 - ₹1,00,000 per month",
        jobType: "Full-time",
        shift: "Hybrid",
        description: "A full-stack engineer is needed with expertise in MERN stack.",
        //active: "Active 1 day ago.",
        skills: ["HTML", "CSS", "JavaScript", "React", "Node.js", "Express", "MongoDB", "AWS"],
        //actives: "Active 5 days ago", // ✅ Added
      ),
      Job(
        id: 5,
        title: "iOS Developer",
        company: "Innovate Labs",
        location: "Delhi, India",
        salary: "₹55,000 - ₹80,000 per month",
        jobType: "Full-time",
        shift: "Day shift",
        description: "Hiring an iOS Developer with strong Swift and SwiftUI skills.",
        //active: "Active 1 day ago.",
        skills: ["Swift", "SwiftUI", "Core Data", "API"],
        //actives: "Active 7 days ago", // ✅ Added
      ),
      Job(
        id: 6,
        title: "DevOps Engineer",
        company: "Cloud Warriors",
        location: "Hyderabad, India",
        salary: "₹80,000 - ₹1,20,000 per month",
        jobType: "Full-time",
        shift: "Rotational",
        description: "Looking for a DevOps Engineer with hands-on experience in Kubernetes and AWS/GCP cloud services.",
        //'  active: "Active 1 day ago.",
        skills: ["Python", "Docker", "Kubernetes", "AWS", "GCP"],
        //actives: "Active 2 days ago", // ✅ Added
      ),
      Job(
        id: 7,
        title: "Software Engineer (AI/ML)",
        company: "AI Vision Tech",
        location: "Remote",
        salary: "₹90,000 - ₹1,50,000 per month",
        jobType: "Remote",
        shift: "Flexible",
        description: "We are looking for an AI/ML Engineer with expertise in TensorFlow and PyTorch.",
        //active: "Active 1 day ago.",
        skills: ["Python", "TensorFlow", "PyTorch", "Deep Learning"],
       // actives: "Active 9 days ago", // ✅ Added
      ),
      Job(
        id: 8,
        title: "Data Analyst",
        company: "Data Insights Pvt Ltd",
        location: "Chennai, India",
        salary: "₹50,000 - ₹75,000 per month",
        jobType: "Full-time",
        shift: "Day shift",
        description: "Looking for a Data Analyst with experience in SQL, Python, and Tableau.",
       // active: "Active 1 day ago.",
        skills: ["SQL", "Python", "Tableau", "Power BI"],
        //actives: "Active 14 days ago", // ✅ Added
      ),
      Job(
        id: 9,
        title: "Cyber Security Engineer",
        company: "SecureTech",
        location: "Bangalore, India",
        salary: "₹1,00,000 - ₹1,50,000 per month",
        jobType: "Full-time",
        shift: "Rotational",
        description: "We are hiring a Cyber Security Engineer to handle vulnerability assessment and network security.",
       // active: "Active 1 day ago.",
        skills: ["Ethical Hacking", "Network Security", "Cyber Security"],
        //actives: "Active 12 days ago", // ✅ Added
      ),
      Job(
        id: 10,
        title: "UX/UI Designer",
        company: "Creative Minds",
        location: "Remote",
        salary: "₹45,000 - ₹70,000 per month",
        jobType: "Contract",
        shift: "Flexible",
        description: "Looking for a UX/UI Designer with experience in Figma and Adobe XD.",
       // active: "Active 1 day ago.",
        skills: ["Figma" ,'Adobe XD' ,"Mobile App", "Design"],
        //actives: "Active 17 days ago", // ✅ Added
      ),
    ];
  }
}
*/
