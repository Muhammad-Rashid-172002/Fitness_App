import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Smallworkout1 extends StatefulWidget {
  const Smallworkout1({super.key});

  @override
  State<Smallworkout1> createState() => _Smallworkout1State();
}

class _Smallworkout1State extends State<Smallworkout1> {
  int _timeLeft = 30; // Start from 30 seconds
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Ensure timer is canceled when widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jumping Jack'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            height: 361,
            width: 400,
            child: LottieBuilder.asset(
              'assets/Aniamation/1 (2).json',
              height: 250,
            ),
          ),
          SizedBox(height: 80),

          // Countdown Timer Display
          Text(
            'Time Left: $_timeLeft sec',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 40),

          Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
            ),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _timeLeft = 30; // Reset timer
                  _startTimer(); // Restart the countdown
                });
              },
              child: const Text(
                'Restart Timer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
