import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outS/workout2.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outS/workout3.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outs/workout1.dart';
import 'package:fitness/Views/Auth_Modules/Sigin.dart';
import 'package:flutter/material.dart';
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
      MaterialPageRoute(builder: (context) => SigninScreen()),
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
        SizedBox(height: 20),
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
  List lists = [
    {
      'title': 'Fat-Burning HIIT',
      'image': 'assets/images/images (1).jpeg',
      'page': Workout1(),
    },
    {
      'title': 'Strength Builder',
      'image': 'assets/images/images (2).jpeg',
      'page': Workout2(),
    },
    {
      'title': 'Core & Stability',
      'image': 'assets/images/images (3).jpeg',
      'page': Workout3(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Workout'), backgroundColor: Colors.blue),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
            ),
            itemCount: 3,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => lists[index]['page'],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 138,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          lists[index]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        lists[index]['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
