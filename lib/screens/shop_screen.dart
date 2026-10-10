import 'package:flutter/material.dart';
import 'filters_screen.dart';
import 'foundation_detail_screen.dart';
import 'primer_detail_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F3),
      appBar: AppBar(
        title: const Text(
          "Shop",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FiltersScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.tune,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: .70,
          children: [
            _product(
              context,
              "Foundation",
              "\$45",
              const FoundationDetailScreen(),
            ),
            _product(
              context,
              "Primer",
              "\$32",
              const PrimerDetailScreen(),
            ),
            _product(
              context,
              "Face Serum",
              "\$38",
              const FoundationDetailScreen(),
            ),
            _product(
              context,
              "Glow Primer",
              "\$29",
              const PrimerDetailScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _product(
    BuildContext context,
    String name,
    String price,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1E9E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.face_retouching_natural,
                  size: 55,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(price),
          ],
        ),
      ),
    );
  }
}