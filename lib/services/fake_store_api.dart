import 'dart:convert';
import 'package:http/http.dart' as http;

class FakeStoreProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;

  FakeStoreProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory FakeStoreProduct.fromJson(Map<String, dynamic> json) {
    return FakeStoreProduct(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Product',
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Beauty',
      image: json['image'] as String? ?? '',
      rating:
          ((json['rating'] as Map<String, dynamic>?)?['rate'] as num?)
              ?.toDouble() ??
          0.0,
    );
  }
}

class FakeStoreApi {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  static Future<List<FakeStoreProduct>> getProducts() async {
    final response = await http
        .get(Uri.parse(baseUrl))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map(
            (item) => FakeStoreProduct.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
