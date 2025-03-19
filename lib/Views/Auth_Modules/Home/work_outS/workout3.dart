import 'package:fitness/Views/Auth_Modules/Home/work_outS/WORKOUTSSS/smallworkout.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outs/WORKOUTSSS/smallworkout1.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outs/WORKOUTSSS/smallworkout2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Workout3 extends StatefulWidget {
  const Workout3({super.key});

  @override
  State<Workout3> createState() => _Workout3State();
}

class _Workout3State extends State<Workout3> {
  List lottieFiles = [
    {
      'title': 'Jumping Jack',
      'image': 'assets/Aniamation/1 (4).json',
      'page': Smallworkout(),
    },
    {
      'title': 'Burpees',
      'image': 'assets/Aniamation/1 (5).json',
      'page': Smallworkout1(),
    },
    {
      'title': 'Pushups',
      'image': 'assets/Aniamation/1 (6).json',
      'page': Smallworkout2(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Core & Stability'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => lottieFiles[index]['page'],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display Lottie animation
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Lottie.asset(
                          lottieFiles[index]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        lottieFiles[index]['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
