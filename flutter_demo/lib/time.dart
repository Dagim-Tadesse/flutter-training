import 'dart:async'; // Needed for Timer
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TimerExample(),
    );
  }
}

class TimerExample extends StatefulWidget {
  const TimerExample({super.key});

  @override
  State<TimerExample> createState() => _TimerExampleState();
}

class _TimerExampleState extends State<TimerExample> {
  int counter = 0;         // value that increases every second
  String message = "";    // message shown after delay
  Timer? timer;           // holds the timer

  @override
  void initState() {
    super.initState();

    // 1️⃣ Runs once after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        message = "3 seconds passed!";
      });
    });

    // 2️⃣ Runs every 1 second
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        counter++;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // stop timer when widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Future & Timer Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Counter: $counter",
                style: const TextStyle(fontSize: 30)),

            const SizedBox(height: 20),

            Text(message,
                style: const TextStyle(fontSize: 22, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
