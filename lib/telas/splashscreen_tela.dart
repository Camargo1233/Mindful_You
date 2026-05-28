import 'package:flutter/material.dart';

import '../services/api_service.dart';

class SplashScreenTela extends StatefulWidget {
  const SplashScreenTela({super.key});

  @override
  State<SplashScreenTela> createState() => _SplashScreenTelaState();
}

class _SplashScreenTelaState extends State<SplashScreenTela> {
  @override
  void initState() {
    super.initState();
    _decidirRotaInicial();
  }

  Future<void> _decidirRotaInicial() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final user = await MockApiService.currentUser();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      user == null ? '/login' : '/inicial',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFEDE7E3),
      body: Center(
        child: Text(
          'MINDFUL\nYOU',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
