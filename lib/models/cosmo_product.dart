class CosmoProduct {
  final int id;
  final String name;
  final String brand;
  final String category;
  final String section;
  final double price;
  final String description;
  final double rating;
  final int stock;
  final String image;

  const CosmoProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.section,
    required this.price,
    required this.description,
    required this.rating,
    required this.stock,
    required this.image,
  });

  factory CosmoProduct.fromJson(Map<String, dynamic> json) {
    return CosmoProduct(
      id: int.tryParse('${json['id'] ?? 0}') ?? 0,
      name: '${json['name'] ?? ''}',
      brand: '${json['brand'] ?? ''}',
      category: '${json['category'] ?? ''}',
      section: '${json['section'] ?? 'FACE'}',
      price: double.tryParse('${json['price'] ?? 0}') ?? 0.0,
      description: '${json['description'] ?? ''}',
      rating: double.tryParse('${json['rating'] ?? 0}') ?? 0.0,
      stock: int.tryParse('${json['stock'] ?? 0}') ?? 0,
      image: '${json['image'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'section': section,
      'price': price,
      'description': description,
      'rating': rating,
      'stock': stock,
      'image': image,
    };
  }
}
