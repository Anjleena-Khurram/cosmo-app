import 'package:flutter/material.dart';

class FoundationDetailScreen extends StatelessWidget {
  const FoundationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F3),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE8D7D1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.face_retouching_natural,
                size: 120,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "DIOR",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Forever Foundation",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "\$45.00",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "A lightweight foundation designed to provide "
              "natural-looking coverage with a smooth finish.",
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Choose Shade",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              children: [
                _shade("01"),
                _shade("02"),
                _shade("03"),
                _shade("04"),
                _shade("05"),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF208AEF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "ADD TO BAG",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shade(String text) {
    return Container(
      width: 50,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFD7B49E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }
}