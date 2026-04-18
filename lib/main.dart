import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'database/db_helper.dart';

void main() async {
  // REQUIRED for async + database
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const FlowDotsApp());
}

class FlowDotsApp extends StatelessWidget {
  const FlowDotsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlowDots',

      // Theme customization
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
      ),

      home: const SplashScreen(),
    );
  }
}