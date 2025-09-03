import 'package:flutter/material.dart';
import 'package:QuickHireRecruiter/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api/ApiService.dart';
import '../../Api/GoogleSignInApi.dart';
import '../../Module/ProfileManager.dart';
import '../MyMainScren.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({Key? key}) : super(key: key);

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController __passwordController = TextEditingController();
  final TextEditingController __confirmPasswordController = TextEditingController();
  bool __isPasswordVisible = false;
  bool __isConfirmPasswordVisible = false;
  bool __isLoading = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Initially password is hidden
  final formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  String? userEmail;
  bool _isButtonEnabled = false;
  String _userEmail = '';
  String _userName = '';
  bool _isGoogleLoading = false;

  Future<void> _signOut() async {
    // Sign out from Google
    await GoogleSignInApi().signOutFromGoogle(context);
    // Additional steps for sign-out (e.g., clear other data if needed)
    print("User signed out");
  }

  final GoogleSignInApi _googleSignInApi = GoogleSignInApi();

  Future<void> _handleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    final user = await _googleSignInApi.signInWithGoogle();

    setState(() {
      _isGoogleLoading = false;
    });

    if (user != null) {
      // Successfully signed in
      setState(() {
        _userEmail = user.email;
        _userName = user.displayName ?? 'No Name';
      });

      // Show the password dialog after Google sign-in is successful
      _showPasswordDialog(_userEmail, _userName);

      // Uncomment if you want to navigate to another screen after successful sign-in
      /*
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyMainScreen()), // Make sure this is the correct screen
    );
    */
    } else {
      // Handle sign-in failure
      print("Sign-In failed.");
    }
  }

  // Retrieve user data from SharedPreferences
  Future<void> _retrieveUserData() async {
    var userData = await _googleSignInApi.getUserData();
    setState(() {
      _userEmail = userData['email'] ?? 'No email';
      _userName = userData['name'] ?? 'No name';
    });
  }

  Future<String?> __signup(String userEmail, String password, String userName,
      String confirmPassword) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Passwords do not match!'),
            backgroundColor: Colors.red),
      );
      return null; // Return null instead of void
    }

    print("User Data: $userEmail, $password, $userName, $confirmPassword");

    setState(() => __isLoading = true);

    var response = await ApiService.registeronsignin(
      userName,
      userEmail,
      password,
      confirmPassword,
    );

    setState(() => __isLoading = false);

    if (response.containsKey("error")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text(response["error"], style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red),
      );
      return null; // Return null if there is an error
    } else {
      String accessToken = response["access_token"]; // Extract token
      print("Access Token: $accessToken");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Signup Successful!",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green),
      );

      return accessToken; // Return the access token
    }
  }

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

      print("Login $email and $password");

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
            MaterialPageRoute(builder: (context) => MyMainScreen()),
          );
        }
      }
      setState(() => _isLoading = false); // Hide loading state after login
    }
  }

  @override
  void initState() {
    super.initState();

  }



  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    __passwordController.dispose();
    __confirmPasswordController.dispose();
    super.dispose();
  }


  void _showPasswordDialog(String userEmail, String userName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Set Your Password for Jobber Login",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'Please set a password for your account associated with'),
                      Text(userName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(userEmail,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      // Password Field
                      const Text("Password *"),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: __passwordController,
                        obscureText: !__isPasswordVisible,
                        validator: (value) => value!.length < 6
                            ? "Password must be at least 6 characters"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(__isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() {
                              __isPasswordVisible = !__isPasswordVisible;
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Confirm Password Field
                      const Text("Confirm Password *"),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: __confirmPasswordController,
                        obscureText: !__isConfirmPasswordVisible,
                        validator: (value) => value != __passwordController.text
                            ? "Passwords do not match"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Re-enter Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(__isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() {
                              __isConfirmPasswordVisible =
                              !__isConfirmPasswordVisible;
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _signOut(); // Implement this method accordingly
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      // Show loading Snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Text('Processing... Please wait'),
                            ],
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );

                      // Call __signup and await the response
                      String? accessToken = await __signup(
                        userEmail,
                        __passwordController.text,
                        userName,
                        __confirmPasswordController.text,
                      );

                      if (accessToken != null) {
                        // Store token in SharedPreferences
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        await prefs.setString('access_token', accessToken);
                        ProfileManager.loadProfileData();
                        // Close the dialog
                        Navigator.pop(context);

                        // Navigate to the next screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyMainScreen()),
                        );
                      } else {
                        // Show error message if signup failed
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                              Text('Signup failed! Please try again.')),
                        );
                      }
                    }
                  },
                  child: Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // Use a BoxDecoration to set a background color or gradient
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    child: Form(
    key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: Image.asset(
                'lib/Assets/Google.png',
                width: 20,
                height: 20,
              ),
              label: const Text('Login with Google', style: TextStyle(color: Colors.black)),
              onPressed: () {
                _handleSignIn();
              },
            ),
            const SizedBox(height: 20),
            // Divider text: "or continue with email"
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade400)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'or continue with email',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade400)),
              ],
            ),
            const SizedBox(height: 20),
            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => _validateForm(),
            ),
            const SizedBox(height: 16),
            // Password TextField with toggle visibility
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
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
                labelText: 'Enter your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => _validateForm(),
            ),
            const SizedBox(height: 8),
            // Forgot Password
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // TODO: Forgot password logic
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Login Button
       /*     SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.customGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
              Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyMainScreen()),  // Replace with your LoginScreen
                  );

                  _login();
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),*/
            // Submit Button with Loading Indicator
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled ? AppColors.customGreen : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isButtonEnabled ? _login : null,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            // Terms of service
            Text(
              'By logging in, you agree to our Terms of service \n 0and Privacy policy',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),

      ),
    ),
    );
  }
}
