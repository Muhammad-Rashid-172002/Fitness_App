import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outS/workout2.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outS/workout3.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outS/workout4.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outs/workout1.dart';
import 'package:fitness/Views/Auth_Modules/Sigin.dart';
import 'package:fitness/Views/Auth_Modules/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int currentIndex = 0;
  final List = [HomeScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: List[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  Future<void> _refreshUser() async {
    await FirebaseAuth.instance.currentUser?.reload(); // Refresh user data
    setState(() {
      user = FirebaseAuth.instance.currentUser; // Update state
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  await _pickImage(ImageSource.gallery);
                  if (mounted) setState(() {});
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () async {
                  await _pickImage(ImageSource.camera);
                  if (mounted) setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Show Confirmation Dialog for Logout
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _logout(); // Perform logout
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  // Show Confirmation Dialog for Account Deletion
  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deleteAccount(); // Perform account deletion
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() async {
    if (user != null) {
      try {
        await user!.delete();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SigninScreen()),
        );
      } catch (e) {
        print("Error deleting account: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Account deletion failed. Please log in again and try.",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Profile'), backgroundColor: Colors.blue),
        SizedBox(height: 50),
        Stack(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage:
                  _image != null
                      ? FileImage(_image!) as ImageProvider
                      : AssetImage('assets/images/default_avatar.png'),
            ),
            Positioned(
              bottom: 7,
              right: 7,
              child: InkWell(
                onTap: () {
                  _showPicker(context);
                },
                child: Icon(Icons.camera_alt, color: Colors.teal, size: 28),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          user?.displayName ?? 'No Name',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          user?.email ?? 'No Email',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        SizedBox(height: 20),

        ListTile(
          leading: Icon(Icons.logout),
          trailing: Icon(Icons.arrow_forward_ios),
          title: Text('Logout'),
          onTap: () => _confirmLogout(context),
        ),
        ListTile(
          leading: Icon(Icons.delete),
          trailing: Icon(Icons.arrow_forward_ios),
          title: Text('Delete Account'),
          onTap: () => _confirmDeleteAccount(context),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Workout'), backgroundColor: Colors.blue),
        SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Workout1()),
                );
              },
              child: Container(
                height: 180,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 200,
                      child: Image.asset('assets/images/images (1).jpeg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Fat-Burning HIIT',
                      style: GoogleFonts.acme(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Workout2()),
                );
              },
              child: Container(
                height: 180,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 200,
                      child: Image.asset('assets/images/images (2).jpeg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Strength Builder',
                      style: GoogleFonts.acme(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Workout3()),
                );
              },
              child: Container(
                height: 180,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 200,
                      child: Image.asset('assets/images/images (3).jpeg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Core & Stability',
                      style: GoogleFonts.acme(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Workout4()),
                );
              },
              child: Container(
                height: 180,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 200,
                      child: Image.asset('assets/images/images (4).jpg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Weight Loss and Build Muscle',
                      style: GoogleFonts.acme(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
