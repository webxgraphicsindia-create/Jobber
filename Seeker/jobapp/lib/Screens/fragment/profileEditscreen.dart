import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:QuickHire/JsonModels/ProfileManager.dart';
import 'package:permission_handler/permission_handler.dart';

class profileEditscreen extends StatefulWidget {
  const profileEditscreen({super.key});

  @override
  _profileEditscreen createState() => _profileEditscreen();
}

class _profileEditscreen extends State<profileEditscreen> {
  File? _image;
  final _picker = ImagePicker();

  final TextEditingController _nameController =
      TextEditingController(text: ProfileManager.userName);
  final TextEditingController _emailController =
      TextEditingController(text: ProfileManager.userEmail);
  final TextEditingController _phoneController =
      TextEditingController(text: ProfileManager.userPhone);

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        requestFullMetadata: false, // Important for Android 10+
      );

      if (pickedFile != null && mounted) {
        setState(() => _image = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _showPermissionDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Upload Photo"),
        content: Text("Choose an option to upload your profile picture."),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleGalleryPermission();
            },
            child: Text("Gallery"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleCameraPermission();
            },
            child: Text("Camera"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGalleryPermission() async {
    if (Platform.isAndroid && await getAndroidSdkVersion() >= 33) {
      // Android 13+ needs READ_MEDIA_IMAGES
      await _handlePermission(Permission.photos);
    } else {
      // Android <13 needs READ_EXTERNAL_STORAGE
      await _handlePermission(Permission.storage);
    }
  }

  Future<void> _handleCameraPermission() async {
    await _handlePermission(Permission.camera);
  }

  Future<void> _handlePermission(Permission permission) async {
    final status = await permission.request();

    if (status.isGranted && mounted) {
      await _pickImage(permission == Permission.camera
          ? ImageSource.camera
          : ImageSource.gallery
      );
    } else if (status.isPermanentlyDenied && mounted) {
      _showPermissionDeniedDialog();
      openAppSettings();
    } else if (mounted) {
      _showPermissionDeniedDialog();
    }
  }

  Future<int> getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final build = await DeviceInfoPlugin().androidInfo;
      return build.version.sdkInt;
    }
    return 0;
  }

  /*Future<void> _handleCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _pickImage(ImageSource.camera);
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      openAppSettings();
    } else {
      _showPermissionDeniedDialog();
    }
  }*/

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Denied"),
        content: Text("Please allow access from settings to upload a photo."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    // Logic to save updated profile details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _showPermissionDialog,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _showPermissionDialog,
                child: Text("Upload Photo"),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField("Fu"
                ""
                "ll Name", _nameController),
            SizedBox(height: 12),
            _buildTextField("Email", _emailController),
            SizedBox(height: 12),
            _buildTextField("Phone Number", _phoneController),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Save Changes",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
