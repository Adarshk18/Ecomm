import 'dart:io';
import 'package:eshopee/views/screens/nav_screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication_screens/login_screen.dart';
import '../inner_Screens/order_screen.dart';
import '../inner_screens/shipping_address_screen.dart';

class AccountScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const AccountScreen(
      {Key? key, required this.userName, required this.userEmail})
      : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;
  File? _profileImage; // Added to store profile image

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _emailController.text = widget.userEmail;
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    String? mobile = prefs.getString('mobile');

    if (imagePath != null && mounted) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }

    if (mobile != null) {
      _mobileController.text = mobile;
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Update display name and email
        await user.updateDisplayName(_nameController.text);
        await user.verifyBeforeUpdateEmail(_emailController.text);
        await user.reload();
        user = _auth.currentUser;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobile', _mobileController.text);

        // Handle profile image update if _profileImage is not null
        if (_profileImage != null) {
          await prefs.setString('profile_image', _profileImage!.path);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to handle image selection
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const LoginScreen()), // Navigate to LoginScreen after logout
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: () => _pickImage(
                ImageSource.gallery), // Open gallery for image selection
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/images/profile11111.jpg')
                          as ImageProvider,
                  // Placeholder or default image if _profileImage is null
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.edit, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                TextField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Update Profile'),
                ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('My Orders'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OrderScreen();
                  }));
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingsScreen();
                  }));
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Add/Update Address'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ShippingAddressScreen();
                  }));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
}
