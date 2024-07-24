import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';

void main() {
  runApp(Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(platform: TargetPlatform.iOS),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

//Developer: Moein Mohammadi :)
// instagram page: @moeinmohammadi1388 