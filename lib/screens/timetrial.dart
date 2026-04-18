import 'package:flutter/material.dart';
import 'dart:async';
import '../services/coin_service.dart';

class TimeTrialPage extends StatefulWidget {
  const TimeTrialPage({super.key});

  @override
  State<TimeTrialPage> createState() => _TimeTrialPageState();
}

class _TimeTrialPageState extends State<TimeTrialPage> {
  int seconds = 30;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
        CoinService.addCoins(15);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Time Trial Completed +15 coins")),
        );
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Time Trial"), backgroundColor: Colors.black),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Time Left: $seconds", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startTimer,
              child: const Text("Start"),
            )
          ],
        ),
      ),
    );
  }
}