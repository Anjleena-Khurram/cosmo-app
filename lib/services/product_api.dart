import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/cosmo_product.dart';

class ProductApi {
  static const String baseUrl = 'http://127.0.0.1:3000/api/products';

  // Fetch all products from the existing backend.
  static Future<List<CosmoProduct>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception('Products API failed: ${response.statusCode}');
      }

      final dynamic decoded = jsonDecode(response.body);

      final List<dynamic> data;

      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map && decoded['products'] is List) {
        data = decoded['products'] as List<dynamic>;
      } else {
        throw Exception('Invalid products API response.');
      }

      return data
          .whereType<Map>()
          .map((item) => CosmoProduct.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      throw Exception('Unable to load products: $e');
    }
  }

  // Compatibility method for Brands Collection and other screens.
  static Future<List<CosmoProduct>> getProducts() {
    return fetchProducts();
  }

  // Search products by name, brand, category or section.
  static Future<List<CosmoProduct>> searchProducts(String query) async {
    final products = await fetchProducts();
    final searchText = query.trim().toLowerCase();

    if (searchText.isEmpty) {
      return products;
    }

    return products.where((product) {
      final details = [
        product.name,
        product.brand,
        product.category,
        product.section,
        product.description,
      ].join(' ').toLowerCase();

      return details.contains(searchText);
    }).toList();
  }

  // Select varied products for Just Arrived.
  static Future<List<CosmoProduct>> fetchJustArrivedProducts({
    int limit = 10,
  }) async {
    final products = await fetchProducts();

    const keywords = [
      'lip gloss',
      'lipgloss',
      'eyebrow',
      'brow pencil',
      'lip liner',
      'lipliner',
      'eyeliner',
      'eye liner',
      'colored mascara',
      'colour mascara',
      'color mascara',
      'hair care',
      'haircare',
      'hair oil',
      'hair mask',
      'serum',
      'skincare',
      'skin care',
    ];

    bool matchesPriority(CosmoProduct product) {
      final details = '${product.name} ${product.category} ${product.section}'
          .toLowerCase();

      return keywords.any((keyword) => details.contains(keyword));
    }

    final selected = <CosmoProduct>[];
    final usedProducts = <String>{};
    final usedCategories = <String>{};

    String productKey(CosmoProduct product) =>
        '${product.brand}|${product.name}'.toLowerCase();

    // First, prioritize requested product types.
    for (final product in products.where(matchesPriority)) {
      if (selected.length >= limit) break;

      final key = productKey(product);
      final category = product.category.trim().toLowerCase();

      if (usedProducts.contains(key)) continue;

      if (usedCategories.add(category)) {
        selected.add(product);
        usedProducts.add(key);
      }
    }

    // Next, add products from other categories.
    for (final product in products) {
      if (selected.length >= limit) break;

      final key = productKey(product);
      final category = product.category.trim().toLowerCase();

      if (usedProducts.contains(key)) continue;

      if (category.isNotEmpty && usedCategories.contains(category)) {
        continue;
      }

      selected.add(product);
      usedProducts.add(key);
      usedCategories.add(category);
    }

    // Fill any remaining spaces if the backend has fewer categories.
    for (final product in products) {
      if (selected.length >= limit) break;

      if (usedProducts.add(productKey(product))) {
        selected.add(product);
      }
    }

    return selected;
  }
}
