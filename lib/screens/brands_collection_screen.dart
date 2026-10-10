import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../services/product_api.dart';
import 'product_detail_api_screen.dart';
import '../models/cosmo_product.dart';

class BrandsCollectionScreen extends StatefulWidget {
  final String? selectedBrand;

  const BrandsCollectionScreen({super.key, this.selectedBrand});

  @override
  State<BrandsCollectionScreen> createState() => _BrandsCollectionScreenState();
}

class _BrandsCollectionScreenState extends State<BrandsCollectionScreen> {
  List<CosmoProduct> _allProducts = [];

  bool _isLoading = true;

  String? _errorMessage;

  late String _selectedBrand;

  final List<String> _brands = ['Dior', 'ESTÉE LAUDER', 'NARS', 'MAC'];

  @override
  void initState() {
    super.initState();

    _selectedBrand = widget.selectedBrand ?? 'Dior';

    _loadProducts();
  }

  // ==========================================
  // LOAD PRODUCTS FROM API
  // ==========================================

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await ProductApi.getProducts();

      if (!mounted) return;

      setState(() {
        _allProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // ==========================================
  // GET PRODUCTS OF SELECTED BRAND
  // ==========================================

  List<CosmoProduct> get _brandProducts {
    return _allProducts.where((product) {
      return product.brand.toLowerCase() == _selectedBrand.toLowerCase();
    }).toList();
  }

  // ==========================================
  // GET PRODUCTS BY SECTION
  // ==========================================

  List<CosmoProduct> _productsBySection(String section) {
    return _brandProducts.where((product) {
      return product.section.toUpperCase() == section.toUpperCase();
    }).toList();
  }

  // ==========================================
  // PRODUCT OPEN
  // ==========================================

  void _openProduct(CosmoProduct product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailFromApi(product: product)),
    );
  }

  // ==========================================
  // PRICE
  // ==========================================

  String _price(double price) {
    return 'Rs. ${price.round()}';
  }

  // ==========================================
  // BRAND COLOR
  // ==========================================

  Color _brandColor(String brand) {
    switch (brand.toUpperCase()) {
      case 'DIOR':
        return const Color(0xFF171717);

      case 'ESTÉE LAUDER':
        return const Color(0xFF6F514A);

      case 'NARS':
        return const Color(0xFF2A2A2A);

      case 'MAC':
        return const Color(0xFF201C1D);

      default:
        return const Color(0xFF2B2523);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F3),

      // ==========================================
      // APP BAR
      // ==========================================
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF5F3),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2B2523)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Brands',
          style: TextStyle(
            color: Color(0xFF2B2523),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),

        centerTitle: true,
      ),

      // ==========================================
      // BODY
      // ==========================================
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _errorView()
          : RefreshIndicator(
              onRefresh: _loadProducts,

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(18, 8, 18, 35),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // BRAND SELECTOR
                    _brandSelector(),

                    const SizedBox(height: 18),

                    // BRAND HEADER
                    _brandHeader(),

                    const SizedBox(height: 25),

                    // FACE
                    _productSection('FACE', _productsBySection('FACE')),

                    const SizedBox(height: 28),

                    // LIPS
                    _productSection('LIPS', _productsBySection('LIPS')),

                    const SizedBox(height: 28),

                    // EYES & BROWS
                    _productSection(
                      'EYES & BROWS',
                      _productsBySection('EYES & BROWS'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ==========================================
  // BRAND SELECTOR
  // ==========================================

  Widget _brandSelector() {
    return SizedBox(
      height: 45,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        itemCount: _brands.length,

        separatorBuilder: (_, __) => const SizedBox(width: 9),

        itemBuilder: (context, index) {
          final brand = _brands[index];

          final isSelected =
              brand.toLowerCase() == _selectedBrand.toLowerCase();

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedBrand = brand;
              });
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),

              padding: const EdgeInsets.symmetric(horizontal: 18),

              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2B2523) : Colors.white,

                borderRadius: BorderRadius.circular(25),

                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2B2523)
                      : const Color(0xFFE6DEDA),
                ),
              ),

              child: Center(
                child: Text(
                  brand,

                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF2B2523),

                    fontSize: 12,

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // BRAND HEADER
  // ==========================================

  Widget _brandHeader() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: _brandColor(_selectedBrand),

        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            _selectedBrand,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            '${_brandProducts.length} products available',

            style: TextStyle(
              color: Colors.white.withOpacity(0.75),

              fontSize: 13,
            ),
          ),

          const SizedBox(height: 15),

          Container(
            width: 45,
            height: 3,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PRODUCT SECTION
  // ==========================================

  Widget _productSection(String title, List<CosmoProduct> products) {
    if (products.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              title,

              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2B2523),
                letterSpacing: 1,
              ),
            ),

            Text(
              '${products.length} items',

              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8D8582),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 13),

        GridView.builder(
          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemCount: products.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,

            crossAxisSpacing: 13,

            mainAxisSpacing: 15,

            childAspectRatio: 0.67,
          ),

          itemBuilder: (context, index) {
            return _productCard(products[index]);
          },
        ),
      ],
    );
  }

  // ==========================================
  // PRODUCT CARD
  // ==========================================

  Widget _productCard(CosmoProduct product) {
    return GestureDetector(
      onTap: () {
        _openProduct(product);
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: const Color(0xFFEDE5E2)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================
            // PRODUCT IMAGE
            // ==================================
            Expanded(
              flex: 6,

              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),

                child: Container(
                  width: double.infinity,

                  color: const Color(0xFFF4EEEC),

                  child: SvgPicture.network(
                    product.image,

                    fit: BoxFit.contain,

                    placeholderBuilder: (context) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF1E9E6),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Icon(
                              Icons.image_outlined,
                              size: 42,
                              color: Color(0xFFAAA19D),
                            ),

                            const SizedBox(height: 6),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),

                              child: Text(
                                product.category,

                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8D8582),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ==================================
            // PRODUCT INFORMATION
            // ==================================
            Expanded(
              flex: 4,

              child: Padding(
                padding: const EdgeInsets.all(11),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      product.category.toUpperCase(),

                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9A918E),
                        letterSpacing: 0.8,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      product.name,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2B2523),
                        height: 1.2,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          _price(product.price),

                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2B2523),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF5F3),

                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Color(0xFFC49A5A),
                              ),

                              const SizedBox(width: 2),

                              Text(
                                product.rating.toString(),

                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ERROR VIEW
  // ==========================================

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 60,
              color: Color(0xFF9A918E),
            ),

            const SizedBox(height: 15),

            const Text(
              'Unable to load products',

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2B2523),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _errorMessage ?? '',

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 12, color: Color(0xFF8D8582)),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loadProducts,

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B2523),

                foregroundColor: Colors.white,

                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 13,
                ),
              ),

              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
