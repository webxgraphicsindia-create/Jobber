import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:QuickHireRecruiter/Module/ProfileManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../JsonModels/JobApplication.dart';
import '../Module/SharePreferencesdata.dart';


class ApiService {
  static const String baseUrl = "https://jobber.riverstonehydration.com/api/admin/employer"; // Base URL

  // Signup function
  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String password, String passwordConfirmation) async {
    final url = Uri.parse("$baseUrl/register");

    try {
      final response = await http.post(
        url,
        body: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        // Extract the error message from the API response
        String errorMessage = responseData["message"] ?? "Signup failed. Please try again.";

        // If email error exists, use it
        if (responseData["errors"] != null && responseData["errors"]["email"] != null) {
          errorMessage = responseData["errors"]["email"][0]; // Get first error message
        }

        return {"error": errorMessage};
      }
    } catch (e) {
      return {"error": "Error: $e"};
    }
  }

  // Register User & Retrieve Access Token
  static Future<Map<String, dynamic>> registeronsignin(
      String name, String email, String password, String passwordConfirmation) async {
    final url = Uri.parse("$baseUrl/register");

    try {
      final response = await http.post(
        url,
        body: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation, // Fixed to match the correct field
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Check if registration was successful & access token exists
        if (data["status"] == true) {

          String? token = data["data"]["access_token"];

          if (token != null) {
            await _saveToken(token);
            //await fetchProfile();// ✅ Save the token
            await SharePreferencesdata.saveProfileData(responseData["data"]); // ✅ Save profile locally
          }
          return {
            "status": true,
            "message": data["message"],
            "data": data["data"],
            "access_token": data["data"]["access_token"], // Return access token
          };
        } else {
          return {
            "error": data["message"] ?? "Signup failed. Please try again!"
          };
        }
      } else {
        return {"error": "Signup failed. Invalid response from the server."};
      }
    } catch (e) {
      return {"error": "Error: $e"};
    }
  }

  //Post Job
  static Future<Map<String, dynamic>> postJob(
      String job_title,
      String company,
      String location,
      String streetAddress,
      String city,
      String state,
      String postalCode,
      String pay,
      String phone, // Changed to String
      List<String> job_type, // Changed to List<String>
      List<String> shift, // Changed to List<String>
      String description,
      List<String> skills
      ) async {
    String? token = ProfileManager.accesstoken;
    final url = Uri.parse("$baseUrl/job/create");

    // Combine address fields into one string
    final String fullAddress = "$streetAddress, $city, $state - $postalCode";

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "job_title": job_title,
          "company": company,
          "location": location,
          "phone": phone,
          "address": fullAddress,
          "pay": pay,
          "job_type": job_type,
          "shift": shift,
          "description": description,
          "skills": skills,
        }),
      ).timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print("🔄 Response Code: ${response.statusCode}");
        print("🔍 Response Body: ${response.body}");
      }

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);

        if (data["status"] == true) {
          return {
            "status": true,
            "message": data["message"],
            "data": data["data"],
          };
        } else {
          return {"error": data["message"] ?? "Job posting failed!"};
        }
      } else {
        return {"error": "Server error: ${response.statusCode}"};
      }
    } on SocketException {
      return {"error": "No Internet connection. Please check your network."};
    } on TimeoutException {
      return {"error": "Request timeout. Please try again later."};
    } on FormatException {
      return {"error": "Invalid response format. Server might be down."};
    } catch (e) {
      return {"error": "Unexpected error: $e"};
    }
  }



  // Login function
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse("$baseUrl/login"); // Correct login endpoint
    print(
      "Url for login $url"
    );
    try {
      final response = await http.post(
        url,
        body: {
          "email": email,
          "password": password,
        },
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print(
          "Server data is $data"
        );
        // Check if login was successful
        if (data["status"] == true) {


          String? token = data["data"]["access_token"];

          if (token != null) {
            await _saveToken(token);
            //await fetchProfile();// ✅ Save the token
            await SharePreferencesdata.saveProfileData(responseData["data"]); // ✅ Save profile locally
          }
          return {
            "status": true,
            "message": data["message"],
            "data": data["data"],  // Extract user data
            "access_token": data["data"]["access_token"],
            // Optional: Save token for further use
          };
        } else {
          // If login fails, return error message
          return {
            "error": data["message"] ?? "Login failed. Please try again!"
          };
        }
      } else {
        return {"error": "Login failed. Invalid response from the server."};
      }
    } catch (e) {
      return {"error": "Error: $e"};
    }
  }

  static Future<List<JobApplication>> fetchApplications(
      String? jobId
      ) async {
    final url = Uri.parse("https://jobber.riverstonehydration.com/api/admin/employer/jobapplication/$jobId");
    String? token = ProfileManager.accesstoken;

    if (token == null || token.isEmpty) {
      throw Exception("No access token found. Please login again.");
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['status'] == true && responseBody['data'] != null) {
          List<dynamic> dataList = responseBody['data'];

          List<JobApplication> allApplications = dataList
              .map((jsonItem) => JobApplication.fromJson(jsonItem))
              .toList();

          return allApplications;
        } else {
          throw Exception("Failed to load job applications: ${responseBody['message']}");
        }
      } else {
        throw Exception("Failed to load job applications. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching job applications: $e");
    }
  }



  static Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // ✅ Retrieve the saved token
  }

  //Get Profile
  static Future<Map<String, dynamic>> fetchProfile() async {
    final url = Uri.parse("$baseUrl/profile");

    String? token = await getToken(); // ✅ Get the saved access token

    if (token == null || token.isEmpty) {
      return {"error": "No access token found. Please login again."};
    }

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token", // ✅ Pass token in the header
          "Content-Type": "application/json",
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["status"] == true) {
        await SharePreferencesdata.saveProfileData(responseData["data"]); // ✅ Save profile locally
        return responseData["data"]; // ✅ Return profile data
      } else {
        return {"error": responseData["message"] ?? "Failed to fetch profile."};
      }
    } catch (e) {
      return {"error": "Error: $e"};
    }
  }

  static Future<List<Map<String, dynamic>>> fetchJobsFromApi() async {
    final url = Uri.parse("$baseUrl/job");
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception("No access token found. Please login again.");
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['status'] == true && responseBody['data'] != null) {
          List<dynamic> dataList = responseBody['data'];
          print("Response body $dataList");

          return List<Map<String, dynamic>>.from(dataList);
        } else {
          throw Exception("Failed to load jobs: ${responseBody['message']}");
        }
      } else {
        throw Exception("Failed to load jobs. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching jobs: $e");
    }
  }


/*


  String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit OTP
  }

  Future<bool> sendOTP(String email, String otp) async {
    String companyEmail = "mohitlengure14@gmail.com";
    String companyPassword = "M@your#12082020"; // Use an App Password for security

    final smtpServer = gmail(companyEmail, companyPassword);

    final message = Message()
      ..from = Address(companyEmail, 'Your Company')
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP code is: $otp\n\nDo not share this with anyone.';

    try {
      await send(message, smtpServer);
      return true;
    } catch (e) {
      print('Failed to send OTP: $e');
      return false;
    }
  }
*/

//forgot password API
/* Future<void> _sendForgotPasswordRequest(String email) async {
    final url = Uri.parse("$baseUrl/forgot-password"); // Update with your actual API URL

    try {
      final response = await http.post(
        url,
        body: {"email": email},
      );

      if (response.statusCode == 200) {
        print("Password reset link sent successfully!");
      } else {
        print("Failed to send reset link.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }*/


}
