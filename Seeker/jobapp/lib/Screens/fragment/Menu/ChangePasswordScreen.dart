import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement password change logic (API call or Firebase)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password changed successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPasswordField("Current Password", _currentPasswordController, _obscureCurrent, () {
                setState(() {
                  _obscureCurrent = !_obscureCurrent;
                });
              }),
              SizedBox(height: 16),
              _buildPasswordField("New Password", _newPasswordController, _obscureNew, () {
                setState(() {
                  _obscureNew = !_obscureNew;
                });
              }),
              SizedBox(height: 16),
              _buildPasswordField("Confirm New Password", _confirmPasswordController, _obscureConfirm, () {
                setState(() {
                  _obscureConfirm = !_obscureConfirm;
                });
              }),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _changePassword,
                  child: Text("Update Password"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Enter $label";
        if (label == "New Password" && value.length < 6) return "Password must be at least 6 characters";
        if (label == "Confirm New Password" && value != _newPasswordController.text) return "Passwords do not match";
        return null;
      },
    );
  }
}
