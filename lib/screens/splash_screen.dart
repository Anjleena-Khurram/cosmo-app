import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'welcome_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _openNextScreen();
  }

  Future<void> _openNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            user != null ? const HomeScreen() : const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F3),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAD8D0),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    size: 55,
                    color: Color(0xFF9D6F63),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'COSMO',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                    color: Color(0xFF382B28),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'love urself better',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF9D6F63),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 45),
                const SizedBox(
                  width: 23,
                  height: 23,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF9D6F63),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
