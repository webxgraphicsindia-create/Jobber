import 'package:flutter/material.dart';
import 'package:QuickHireRecruiter/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api/ApiService.dart';
import '../../Module/ProfileManager.dart';
import '../MyMainScren.dart';
import 'TasktugasAuthScreen.dart';
import 'loginScreen.dart';

class SignUpTab extends StatefulWidget {
  const SignUpTab({Key? key}) : super(key: key);

  @override
  State<SignUpTab> createState() => _SignupTabState();
}

class _SignupTabState extends State<SignUpTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false; // Initially password is hidden
  bool _isPasswordconformVisible = false; // Initially password is hidden
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();


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

  Future<void> _signup() async {
    if (formKey.currentState!.validate())
      {
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
          MaterialPageRoute(builder: (context) => const TasktugasAuthScreen()),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    child: Form(
    key: formKey,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Password
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
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Password
              TextField(
                controller: _confirmPasswordController,
                obscureText:  !_isPasswordconformVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordconformVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordconformVisible = !_isPasswordconformVisible;
                      });
                    },
                  ),
                  labelText: 'Confirm your password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 8),
              // Password Requirements (example)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '• At least 8 characters\n• At least 1 number\n• Both upper and lower case letters',
                      style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.customGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                    onPressed: () async {
                      if (formKey.currentState?.validate() == true) {
                        await _signup(); // ✅ This will trigger the signup process
                      } else {
                        // Optionally show validation failed message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill all fields correctly'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Terms of service
              Text(
                'By signing up, you agree to our Terms of service\nand Privacy policy',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
