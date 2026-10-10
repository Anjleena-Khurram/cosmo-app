import 'package:flutter/material.dart';
import '../models/cosmo_product.dart';
import '../services/product_api.dart';

class ApiProductsScreen extends StatefulWidget {
  const ApiProductsScreen({super.key});

  @override
  State<ApiProductsScreen> createState() => _ApiProductsScreenState();
}

class _ApiProductsScreenState extends State<ApiProductsScreen> {
  late Future<List<CosmoProduct>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductApi.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COSMO Products'),
        backgroundColor: const Color(0xFFF4E6DF),
      ),
      body: FutureBuilder<List<CosmoProduct>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading products:\n${snapshot.error}'),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          // LOOP: API ki har product par card banta hai.
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child:
                              product.image != null &&
                                  product.image!.startsWith('http')
                              ? Image.network(
                                  product.image!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image_outlined,
                                      size: 45,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 45,
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        product.brand,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text('Rs. ${product.price.toStringAsFixed(0)}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
