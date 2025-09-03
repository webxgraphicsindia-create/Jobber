
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:QuickHire/Screens/Auth/SignupScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../JsonModels/ProfileManager.dart';
import '../API/ApiService.dart';
import '../MainScreen/MainScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<MyLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isButtonEnabled = false;
  bool _isLoading = false;  // To track API call progress
  final storage = FlutterSecureStorage();

  void _validateForm() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Show loading state

      String email = _emailController.text;
      String password = _passwordController.text;

      var response = await ApiService.loginUser(email, password);

      if (response.containsKey("error")) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["error"], style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );

        // ✅ Store access token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', response["access_token"]);

        // ✅ Load user profile data before navigating
        await ProfileManager.loadProfileData();

        // ✅ After profile data is loaded, navigate to MainScreen
        if (mounted) {  // Check if widget is still in the tree
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyMainScren()),
          );
        }
      }
      setState(() => _isLoading = false); // Hide loading state after login
    }
  }


  String? userEmail;






  @override
  void initState() {
    super.initState();
     // Retrieve user data on startup
  }


  void _showForgotPasswordDialog() {
    TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        final s = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(
            s.forgotPassword,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.blueAccent ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  s.enterCredentials,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: s.enterEmailAddress,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(s.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  String email = emailController.text.trim();

                  // Call the Forgot Password API (implement it in your API service)
                 // _sendForgotPasswordRequest(email);

                  // Close the dialog
                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Password reset link sent to $email"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text(s.submit),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // ✅ Show loader while login & profile loading
          : LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth > 600 ? 150 : 24,
                vertical: 50
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      s.appName,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    s.login,
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    s.enterCredentials,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 20),

                  // Email Field
                  Text(s.emailAddress),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: s.enterEmailAddress,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => _validateForm(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),

                  // Password Field
                  Text(s.password),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: s.enterPassword,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) => _validateForm(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _showForgotPasswordDialog,
                      child: Text(
                        s.forgotPassword,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Submit Button with Loading Indicator
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonEnabled ? Colors.blueAccent : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isButtonEnabled ? _login : null,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(s.loginButton, style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),

                  SizedBox(height: 10),
                  // Sign Up Navigation
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MySignup())),
                      child: RichText(
                        text: TextSpan(
                          text: s.dontHaveAccount,
                          style: const TextStyle(color: Colors.black54, fontSize: 17),
                          children: [
                            TextSpan(
                              text: s.signUp,
                              style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // OR Divider
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(s.or, style: const TextStyle(color: Colors.grey)),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 20),




                ],
              ),
            ),
          );
        },
      ),
    );
  }



}

