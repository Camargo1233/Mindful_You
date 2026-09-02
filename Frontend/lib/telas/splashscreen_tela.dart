import 'package:flutter/material.dart';

class SplashScreenTela extends StatelessWidget {
  const SplashScreenTela({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      backgroundColor: Color(0xFFEDE7E3),
      body: Center(
        child: Text(
          "MINDFUL\nYOU",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, letterSpacing: 2),
        ),
      ),
    );
  }
}
