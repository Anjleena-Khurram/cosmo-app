import 'package:flutter/material.dart';

import '../services/product_api.dart';
import 'notification_center_screen.dart';
import 'shop_screen.dart';
import 'explore_screen.dart';
import 'learn_screen.dart';
import 'product_detail_api_screen.dart';
import 'search_screen.dart';
import 'brands_collection_screen.dart';
import '../models/cosmo_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color beige = Color(0xFFFAF5F3);
  static const Color brown = Color(0xFF4B3028);
  static const Color rose = Color(0xFF9D6F63);

  List<CosmoProduct> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentIndex = 0;

  final List<Map<String, String>> _categories = [
    {
      'name': 'Foundation',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9rgy_l3yzOfrl1QKBlWoBKwUc4QjUTyTrtX9Qy7VMXQ&s=10',
    },
    {
      'name': 'Blush',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoZJjpqgRgvazp6z-1kSzPzPONm12nAt2Xn-9uQ_4pUg&s=10',
    },
    {
      'name': 'Lipstick',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiMcqRW412Jnuym_ZMCnAUONl7tyxtxmukKnwFCkrQSw&s=10',
    },
    {
      'name': 'Mascara',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUCTQ59vv2pQK8Ff5TpPDmkOiZLSIpMxXyhE_QydItNA&s=10',
    },
    {
      'name': 'Nail Polish',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUcoIh5asfj65_sGmteLs4tKbyZKgOw_URagDadcOtFg&s=10',
    },
    {
      'name': 'Skincare',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkYb2iDdh4FwS-h4vjFWjZmYpK-xT-70zFIZxuGh8ufA&s=10',
    },
    {
      'name': 'Hair Care',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVjpZ7spRdlktjPA3WWfWKqdT9B7pceatq9vmedpih_w&s=10',
    },
    {
      'name': 'Perfume',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQc1Je6sNUXBfAO7vOBWGcOtdcX577L9NpDUL7nFirc8Q&s=10',
    },
    {
      'name': 'Compact',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRq4pAkKPjCc8FjxwoH5T81gxXAZfw36hqSxfePJ_9UmA&s=10',
    },
    {
      'name': 'Eyeshadow',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTmQZltkY8xheL1Mph1A8AFKqAzpE_ORpGAYz6wnfbAw&s=10',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final products = await ProductApi.fetchProducts();

      if (!mounted) return;

      setState(() {
        _products = products;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });

      debugPrint('COSMO product loading error: $e');
    }
  }

  void _openProduct(CosmoProduct product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailFromApi(product: product)),
    );
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  void _openShop() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ShopScreen()),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      setState(() => _currentIndex = 0);
      return;
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ShopScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ExploreScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LearnScreen()),
      );
    }

    setState(() => _currentIndex = index);
  }

  // Prioritize the requested newer product types.
  // Products are selected from the existing backend only.
  List<CosmoProduct> _getArrivals() {
    const preferredKeywords = [
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
      'serum',
      'hair oil',
      'hair mask',
      'skin care',
      'skincare',
    ];

    final arrivals = <CosmoProduct>[];
    final addedIds = <String>{};

    String identity(CosmoProduct product) =>
        '${product.brand}|${product.name}'.toLowerCase();

    // First, show products matching the requested variety.
    for (final keyword in preferredKeywords) {
      for (final product in _products) {
        final searchable =
            '${product.name} ${product.category} ${product.section}'
                .toLowerCase();

        if (searchable.contains(keyword)) {
          final id = identity(product);

          if (addedIds.add(id)) {
            arrivals.add(product);
          }

          break;
        }
      }
    }

    // Fill the remaining places with different product categories.
    final seenCategories = <String>{};

    for (final product in arrivals) {
      seenCategories.add(product.category.trim().toLowerCase());
    }

    for (final product in _products) {
      if (arrivals.length >= 10) break;

      final id = identity(product);
      final category = product.category.trim().toLowerCase();

      if (!addedIds.contains(id) &&
          category.isNotEmpty &&
          !seenCategories.contains(category)) {
        arrivals.add(product);
        addedIds.add(id);
        seenCategories.add(category);
      }
    }

    // If there are not enough different categories, fill with other products.
    for (final product in _products) {
      if (arrivals.length >= 10) break;

      final id = identity(product);

      if (addedIds.add(id)) {
        arrivals.add(product);
      }
    }

    return arrivals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProducts,
          color: rose,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COSMO',
                            style: TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4.5,
                              color: brown,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your beauty, your ritual.',
                            style: TextStyle(
                              color: rose,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Notifications',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationCenterScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        size: 27,
                        color: brown,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Shopping bag',
                      onPressed: _openShop,
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 25,
                        color: brown,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // SEARCH BAR
                InkWell(
                  onTap: _openSearch,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE8DCD6)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, color: rose, size: 23),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Find your beauty favourites',
                            style: TextStyle(
                              color: Color(0xFF93827C),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Icon(Icons.tune_rounded, size: 20, color: brown),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ORIGINAL BANNER - UNCHANGED
                ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: SizedBox(
                    height: 190,
                    width: double.infinity,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=1200&q=90',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFEAD6CA),
                          child: const Center(
                            child: Icon(
                              Icons.spa_outlined,
                              color: rose,
                              size: 55,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 29),

                const Text(
                  'Find Your Favourites',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: brown,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Little things that make you glow.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF88736B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 17),

                // ORIGINAL CATEGORY IMAGES - URLS UNCHANGED
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.98,
                  ),
                  itemBuilder: (context, index) {
                    final category = _categories[index];

                    return _categoryCard(category['name']!, category['image']!);
                  },
                ),

                const SizedBox(height: 30),

                // JUST ARRIVED
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Just Arrived',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              color: brown,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Fresh finds for your beauty shelf.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF88736B),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _openShop,
                      child: const Text(
                        'View all  →',
                        style: TextStyle(
                          color: rose,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _buildProducts(),

                const SizedBox(height: 30),

                // TOP BRANDS - UNCHANGED
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'The Beauty Edit',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: brown,
                      ),
                    ),
                    TextButton(
                      onPressed: _openShop,
                      child: const Text(
                        'Explore',
                        style: TextStyle(color: rose),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'A few iconic names we love.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF88736B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 15),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _brandCard('Dior'),
                    _brandCard('Estee Lauder'),
                    _brandCard('NARS'),
                    _brandCard('MAC'),
                  ],
                ),

                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'love urself better ♡',
                    style: TextStyle(
                      color: rose,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex.clamp(0, 3),
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: brown,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Learn',
          ),
        ],
      ),
    );
  }

  // CATEGORY CARDS - SAME IMAGES, SLIGHTLY SMALLER DISPLAY
  Widget _categoryCard(String title, String imageUrl) {
    return InkWell(
      onTap: _openShop,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEDE4DF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF0E4DE),
                          child: const Center(
                            child: Icon(
                              Icons.spa_outlined,
                              color: rose,
                              size: 35,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: brown,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: rose,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // JUST ARRIVED - REAL PRODUCTS FROM YOUR BACKEND
  Widget _buildProducts() {
    if (_isLoading) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator(color: rose)),
      );
    }

    if (_errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined, color: rose, size: 36),
            const SizedBox(height: 10),
            const Text(
              'Your beauty picks are taking a little break.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, color: brown),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check your backend and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            TextButton(
              onPressed: _loadProducts,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'New beauty favourites will appear here soon.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    final arrivals = _getArrivals();

    return SizedBox(
      height: 252,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: arrivals.length,
        separatorBuilder: (_, __) => const SizedBox(width: 11),
        itemBuilder: (context, index) {
          final product = arrivals[index];
          final imageUrl = product.image;

          return InkWell(
            onTap: () => _openProduct(product),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 154,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDE4DF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Smaller image area; original image URL unchanged.
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: imageUrl.trim().isNotEmpty
                            ? Image.network(
                                imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_outlined,
                                    color: rose,
                                    size: 34,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.image_outlined,
                                color: rose,
                                size: 34,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    product.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      letterSpacing: 0.7,
                      color: rose,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: brown,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Rs. ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: brown,
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

  Widget _brandCard(String brand) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BrandsCollectionScreen(selectedBrand: brand),
          ),
        );
      },
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFE8DCD6)),
        ),
        child: Text(
          brand,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: brown,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
