import 'package:fitness/Views/Auth_Modules/Home/work_outS/WORKOUTSSS/smallworkout.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outs/WORKOUTSSS/smallworkout1.dart';
import 'package:fitness/Views/Auth_Modules/Home/work_outs/WORKOUTSSS/smallworkout2.dart';
import 'package:flutter/material.dart';

class Workout2 extends StatefulWidget {
  const Workout2({super.key});

  @override
  State<Workout2> createState() => _Workout2State();
}

class _Workout2State extends State<Workout2> {
  List lottieFiles = [
    {
      'title': 'Jumping Jack',
      'image': 'assets/Aniamation/1 (1).json',
      'page': Smallworkout(),
    },
    {
      'title': 'Burpees',
      'image': 'assets/Aniamation/1 (2).json',
      'page': Smallworkout1(),
    },
    {
      'title': 'Pushups',
      'image': 'assets/Aniamation/1 (3).json',
      'page': Smallworkout2(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
