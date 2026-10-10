import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color background = Color(0xFFFAF5F3);
  static const Color darkBrown = Color(0xFF382B28);
  static const Color roseBrown = Color(0xFF9D6F63);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // COSMO BRAND
              const Center(
                child: Column(
                  children: [
                    Text(
                      'COSMO',
                      style: TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                        color: darkBrown,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'BEAUTY • CARE • CONFIDENCE',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 2.2,
                        fontWeight: FontWeight.w600,
                        color: roseBrown,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 23),

              // MAKEUP IMAGE BLOCK
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=1200&q=85',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;

                          return Container(
                            color: const Color(0xFFEAD8D0),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: roseBrown,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFEAD8D0),
                            child: const Center(
                              child: Icon(
                                Icons.spa_outlined,
                                size: 75,
                                color: roseBrown,
                              ),
                            ),
                          );
                        },
                      ),

                      // Subtle bottom gradient
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 115,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.38),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Positioned(
                        left: 20,
                        bottom: 20,
                        child: Text(
                          'YOUR BEAUTY, YOUR WAY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // STYLISH WELCOME TEXT
              const Text(
                'A little glow,',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                  color: darkBrown,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 1),
              const Text(
                'a lot of confidence.',
                style: TextStyle(
                  fontSize: 31,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: roseBrown,
                  letterSpacing: -0.7,
                ),
              ),

              const SizedBox(height: 11),

              const Text(
                'Discover your beauty essentials and make '
                'every day feel a little more special.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.65,
                  color: Color(0xFF786965),
                  letterSpacing: 0.15,
                ),
              ),

              const SizedBox(height: 22),

              // CREATE ACCOUNT BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 9),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: darkBrown,
                    side: const BorderSide(color: Color(0xFFD7BDB4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'I already have an account',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  'love urself better ♡',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.1,
                    color: roseBrown,
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
