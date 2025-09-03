import 'package:flutter/material.dart';
import 'package:QuickHire/JsonModels/ProfileManager.dart';
import 'package:QuickHire/Screens/API/ApiService.dart';
import 'package:QuickHire/Screens/Auth/LoginScreen.dart';
import 'package:QuickHire/Screens/MainScreen/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../API/GoogleSignInApi.dart';

class MySignup extends StatefulWidget {
  const MySignup({super.key});

  @override
  State<MySignup> createState() => _MySignupState();
}

class _MySignupState extends State<MySignup> {
  final _formKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController __passwordController = TextEditingController();
  final TextEditingController __confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool __isPasswordVisible = false;
  bool __isConfirmPasswordVisible = false;
  bool _isButtonEnabled = false;
  bool __isButtonEnabled = false;
  bool _isLoading = false;
  bool __isLoading = false;
  bool _isGoogleLoading = false;

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text ==
              _confirmPasswordController.text; // Ensure passwords match
    });
  }

  void __validateForm() {
    setState(() {
      __isButtonEnabled = __passwordController.text.isNotEmpty &&
          __confirmPasswordController.text.isNotEmpty &&
          __passwordController.text ==
              __confirmPasswordController.text; // Ensure passwords match
    });
  }

  Future<void> _signOut() async {
    // Sign out from Google
    await GoogleSignInApi().signOutFromGoogle(context);
    // Additional steps for sign-out (e.g., clear other data if needed)
    print("User signed out");
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String password_confirmation = _confirmPasswordController.text;

      var response = await ApiService.registerUser(name, email, password, password_confirmation);

      setState(() => _isLoading = false);

      if (response.containsKey("error")) {
        // Show error message from API response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["error"], style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.containsKey("status") && response["status"] == false) {
        // If API returns status: false, display message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"], style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Signup successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signup Successful!", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyLogin()),
        );
      }
    }
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

                        // Close the dialog
                        Navigator.pop(context);
                        ProfileManager.loadProfileData();
                        // Navigate to the next screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyMainScren()),
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


  String? userEmail;

  String _userEmail = '';
  String _userName = '';
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

  @override
  void initState() {
    super.initState();
    _retrieveUserData(); // Retrieve user data on startup
    _validateForm();
    __validateForm();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth > 600 ? 150 : 24,
                vertical: 50),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      s.createAccount ,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.fillDetails ,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  // Name Field
                  Text(s.fullName),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _nameController,
                    onChanged: (value) => _validateForm(),
                    // ✅ Call _validateForm
                    validator: (value) =>
                        value!.isEmpty ? s.pleaseEnterYourEmail : null,
                    decoration: InputDecoration(
                      hintText: s.enterFullName ,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Email Field
                  Text(s.emailAddress),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    onChanged: (value) => _validateForm(),
                    // ✅ Call _validateForm
                    validator: (value) =>
                        value!.isEmpty ? s.pleaseEnterYourEmail : null,
                    decoration: InputDecoration(
                      hintText: s.enterEmailAddress ,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Password Field
                   Text(s.password),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    onChanged: (value) => _validateForm(),
                    // ✅ Call _validateForm
                    validator: (value) => value!.length < 6
                        ? s.passwordLengthError
                        : null,
                    decoration: InputDecoration(
                      hintText: s.enterPassword,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Confirm Password Field
                  Text(s.confirmPassword),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    onChanged: (value) => _validateForm(),
                    // ✅ Call _validateForm
                    validator: (value) => value != _passwordController.text
                        ? s.passwordsDoNotMatch
                        : null,
                    decoration: InputDecoration(
                      hintText: s.reEnterPassword,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(_isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(() =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isButtonEnabled ? Colors.blueAccent : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _isButtonEnabled ? _signup : null,
                      // ✅ Correctly enable/disable button
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(s.signUp,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Navigation
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyLogin())),
                      child: RichText(
                        text: TextSpan(
                          text: s.alreadyHaveAccount,
                          style: const TextStyle(color: Colors.black54, fontSize: 17),
                          children: [
                            TextSpan(
                              text: s.login,
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

                  // Sign Up with Google Button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _handleSignIn,
                    child: SizedBox(
                      width:
                          double.infinity, // Ensures full width is maintained
                      height: 30, // Fixed height
                      child: Center(
                        child: _isGoogleLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.blueAccent)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("lib/assets/Google.jpg",
                                      height: 20, width: 20),
                                  const SizedBox(width: 10),
                                  Text(s.googleSignUp,
                                      style: const TextStyle(
                                          color: Colors.black87, fontSize: 16)),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
