import 'package:flutter/material.dart';

import 'category_products_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  // ===============================================================
  // ALL COSMO CATEGORIES
  // ===============================================================

  static const List<Map<String, String>> categories = [
    {
      'name': 'Makeup',
      'image':
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Skincare',
      'image':
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Fragrance',
      'image':
          'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Hair Care',
      'image':
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Body Care',
      'image':
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Compact Powder',
      'image':
          'https://images.unsplash.com/photo-1631214524020-7e18db9a8f92?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Foundation',
      'image':
          'https://images.unsplash.com/photo-1596704017254-9b121068fb31?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Concealer',
      'image':
          'https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Blush',
      'image':
          'https://images.unsplash.com/photo-1583241800698-e8ab01830a07?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Eyeshadow',
      'image':
          'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Eyeliner',
      'image':
          'https://images.unsplash.com/photo-1631730486784-9e4a5c0c4a6d?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Mascara',
      'image':
          'https://images.unsplash.com/photo-1583001931096-959e9a1a6223?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Lipstick',
      'image':
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Lip Gloss',
      'image':
          'https://images.unsplash.com/photo-1631214524020-7e18db9a8f92?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Nail Paint',
      'image':
          'https://images.unsplash.com/photo-1604654894610-df63bc536371?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Makeup Tools',
      'image':
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Hair Styling',
      'image':
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=500&q=80',
    },
    {
      'name': 'Perfume',
      'image':
          'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=500&q=80',
    },
  ];

  // ===============================================================
  // CATEGORY → API SEARCH QUERY
  // ===============================================================

  static String _getSearchQuery(String category) {
    switch (category) {
      case 'Makeup':
        return 'makeup';

      case 'Skincare':
        return 'skin';

      case 'Fragrance':
        return 'perfume';

      case 'Hair Care':
        return 'hair';

      case 'Body Care':
        return 'body';

      case 'Compact Powder':
        return 'powder';

      case 'Foundation':
        return 'foundation';

      case 'Concealer':
        return 'concealer';

      case 'Blush':
        return 'blush';

      case 'Eyeshadow':
        return 'eyeshadow';

      case 'Eyeliner':
        return 'eyeliner';

      case 'Mascara':
        return 'mascara';

      case 'Lipstick':
        return 'lipstick';

      case 'Lip Gloss':
        return 'lip gloss';

      case 'Nail Paint':
        return 'nail';

      case 'Makeup Tools':
        return 'makeup tools';

      case 'Hair Styling':
        return 'hair styling';

      case 'Perfume':
        return 'perfume';

      default:
        return category;
    }
  }

  // ===============================================================
  // OPEN CATEGORY
  // ===============================================================

  void _openCategory(BuildContext context, String categoryName) {
    final searchQuery = _getSearchQuery(categoryName);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsScreen(
          categoryName: categoryName,
          searchQuery: searchQuery,
        ),
      ),
    );
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F3),

      // =============================================================
      // APP BAR
      // =============================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF5F3),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),

        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // =============================================================
      // CATEGORY GRID
      // =============================================================
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),

        itemCount: categories.length,

        physics: const BouncingScrollPhysics(),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.82,
        ),

        itemBuilder: (context, index) {
          final category = categories[index];

          final String categoryName = category['name']!;

          final String imageUrl = category['image']!;

          return GestureDetector(
            onTap: () {
              _openCategory(context, categoryName);
            },

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              clipBehavior: Clip.antiAlias,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // =================================================
                  // CATEGORY IMAGE
                  // =================================================
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,

                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }

                              return Container(
                                color: const Color(0xFFE8D7D0),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },

                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFE8D7D0),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 45,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // =========================================
                        // ARROW
                        // =========================================
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =================================================
                  // CATEGORY NAME
                  // =================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
                    child: Text(
                      categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
