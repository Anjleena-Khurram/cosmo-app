import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  double minPrice = 10;
  double maxPrice = 100;

  final List<String> brands = [
    "Dior",
    "Estée Lauder",
    "Chanel",
    "Clinique",
    "Bobbi Brown",
    "MAC",
    "Maybelline",
  ];

  String selectedBrand = "Dior";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F3),
      appBar: AppBar(
        title: const Text(
          "Filters",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                minPrice = 10;
                maxPrice = 100;
                selectedBrand = "Dior";
              });
            },
            child: const Text("Reset"),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Price Range",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                RangeSlider(
                  values: RangeValues(minPrice, maxPrice),
                  min: 0,
                  max: 200,
                  divisions: 20,
                  labels: RangeLabels(
                    "\$${minPrice.round()}",
                    "\$${maxPrice.round()}",
                  ),
                  onChanged: (value) {
                    setState(() {
                      minPrice = value.start;
                      maxPrice = value.end;
                    });
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  "Age",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  children: [
                    _chip("All"),
                    _chip("18+"),
                    _chip("25+"),
                    _chip("35+"),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  "Brands",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ...brands.map(
                  (brand) {
                    return RadioListTile<String>(
                      title: Text(brand),
                      value: brand,
                      groupValue: selectedBrand,
                      onChanged: (value) {
                        setState(() {
                          selectedBrand = value!;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF208AEF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "APPLY FILTERS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String title) {
    return Chip(
      label: Text(title),
      backgroundColor: Colors.white,
    );
  }
}