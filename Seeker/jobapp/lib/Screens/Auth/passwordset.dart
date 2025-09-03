

import 'package:flutter/material.dart';
import 'package:QuickHire/Screens/API/GoogleSignInApi.dart';

import '../API/ApiService.dart';
import 'LoginScreen.dart';

class MyPasswordset extends StatefulWidget {
  const MyPasswordset({super.key});

  @override
  State<MyPasswordset> createState() => _MyPasswordsetState();
}

class _MyPasswordsetState extends State<MyPasswordset> {

  final _formkey = GlobalKey<FormState>();
  final TextEditingController __passwordController = TextEditingController();
  final TextEditingController __confirmPasswordController = TextEditingController();

  bool __isPasswordVisible = false;
  bool __isConfirmPasswordVisible = false;
  bool __isLoading = false;
  bool __isGoogleLoading = false;
  bool __isButtonEnabled = false;

  void __validateForm() {
    setState(() {
      __isButtonEnabled =
          __passwordController.text.isNotEmpty &&
              __confirmPasswordController.text.isNotEmpty &&
              __passwordController.text == __confirmPasswordController.text ; // Ensure passwords match
    });
  }
  Future<void> _signOut() async {
    // Sign out from Google
    await GoogleSignInApi().signOutFromGoogle(context);
    // Additional steps for sign-out (e.g., clear other data if needed)
    print("User signed out");
  }

  Future<void> __signup(
      String userEmail,
      String password,
      String userName,
      String confirmPassword
      ) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => __isLoading = true);

    // Call your API service to register the user
    var response = await ApiService.registerUser(userName, userEmail, password, confirmPassword);

    setState(() => __isLoading = false);

    if (response.containsKey("error")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["error"], style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
      );

      // Navigate to login screen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyLogin()), // Replace MyLogin with your login screen
      );
    }
  }


  // Method to open the dialog
  void _showPasswordDialog(String userEmail, String userName) {
    showDialog(
      context: context,
      barrierDismissible: false, // To prevent closing the dialog by tapping outside
      builder: (context) {
        return AlertDialog(
          title: Text('Set Your Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please set a password for your account associated with $userName ($userEmail)'),

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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(__isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => __isPasswordVisible = !__isPasswordVisible),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(__isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => __isConfirmPasswordVisible = !__isConfirmPasswordVisible),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                _signOut();
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formkey.currentState?.validate() == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords match!')),
                  );

                  // Call _signup with the email, password, and user info
                  __signup(
                    userEmail,  // Email passed to dialog
                    __passwordController.text,  // Password from form
                    userName,  // Name passed to dialog
                    __confirmPasswordController.text,  // Confirm password from form
                  );

                  Navigator.pop(context); // Close the dialog after submission
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Set"),
        centerTitle: true,
      ),
        body: SingleChildScrollView(
        child: Column(
        children: [
          ]
    )
        )
    );

  }

}