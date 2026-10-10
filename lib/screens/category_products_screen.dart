import 'package:flutter/material.dart';

import '../services/product_api.dart';
import '../models/cosmo_product.dart';
import 'product_detail_api_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  final String searchQuery;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.searchQuery,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<CosmoProduct> _products = [];
  List<CosmoProduct> _filteredProducts = [];

  bool _isLoading = true;

  // ===============================================================
  // FILTER VALUES
  // ===============================================================

  double _minPrice = 0;
  double _maxPrice = 1000;

  double _minimumRating = 0;

  String _selectedBrand = 'All Brands';

  // ===============================================================
  // SORT
  // ===============================================================

  String _selectedSort = 'Relevance';

  final List<String> _sortOptions = [
    'Relevance',
    'Price: Low to High',
    'Price: High to Low',
    'Rating: High to Low',
    'Name: A to Z',
  ];

  @override
  void initState() {
    super.initState();
    _loadCategoryProducts();
  }

  // ===============================================================
  // LOAD PRODUCTS
  // ===============================================================

  Future<void> _loadCategoryProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await ProductApi.searchProducts(widget.searchQuery);

      if (!mounted) return;

      setState(() {
        _products = products;
        _isLoading = false;
      });

      _applyFiltersAndSort();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      debugPrint('Category Product Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load products. Please try again.'),
        ),
      );
    }
  }

  // ===============================================================
  // APPLY FILTERS + SORT
  // ===============================================================

  void _applyFiltersAndSort() {
    List<CosmoProduct> results = List.from(_products);

    // -------------------------------------------------------------
    // PRICE
    // -------------------------------------------------------------

    results = results.where((product) {
      return product.price >= _minPrice && product.price <= _maxPrice;
    }).toList();

    // -------------------------------------------------------------
    // RATING
    // -------------------------------------------------------------

    results = results.where((product) {
      return product.rating >= _minimumRating;
    }).toList();

    // -------------------------------------------------------------
    // BRAND
    // -------------------------------------------------------------

    if (_selectedBrand != 'All Brands') {
      results = results.where((product) {
        return product.brand.toLowerCase() == _selectedBrand.toLowerCase();
      }).toList();
    }

    // -------------------------------------------------------------
    // SORT
    // -------------------------------------------------------------

    switch (_selectedSort) {
      case 'Price: Low to High':
        results.sort((a, b) => a.price.compareTo(b.price));
        break;

      case 'Price: High to Low':
        results.sort((a, b) => b.price.compareTo(a.price));
        break;

      case 'Rating: High to Low':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;

      case 'Name: A to Z':
        results.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;

      case 'Relevance':
      default:
        break;
    }

    setState(() {
      _filteredProducts = results;
    });
  }

  // ===============================================================
  // AVAILABLE BRANDS
  // ===============================================================

  List<String> _getAvailableBrands() {
    final brands = _products
        .map((product) => product.brand.trim())
        .where((brand) => brand.isNotEmpty)
        .toSet()
        .toList();

    brands.sort();

    return ['All Brands', ...brands];
  }

  // ===============================================================
  // RESET
  // ===============================================================

  void _resetFilters() {
    setState(() {
      _minPrice = 0;
      _maxPrice = 1000;
      _minimumRating = 0;
      _selectedBrand = 'All Brands';
      _selectedSort = 'Relevance';
    });

    _applyFiltersAndSort();
  }

  // ===============================================================
  // SORT SHEET
  // ===============================================================

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF5F3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 18),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sort products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),

              const SizedBox(height: 12),

              ..._sortOptions.map((option) {
                final selected = _selectedSort == option;

                return ListTile(
                  contentPadding: EdgeInsets.zero,

                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),

                  trailing: selected
                      ? const Icon(Icons.check_circle, color: Colors.black)
                      : const Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.black26,
                        ),

                  onTap: () {
                    setState(() {
                      _selectedSort = option;
                    });

                    Navigator.pop(context);

                    _applyFiltersAndSort();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // ===============================================================
  // FILTER SHEET
  // ===============================================================

  void _showFilterSheet() {
    double tempMinPrice = _minPrice;
    double tempMaxPrice = _maxPrice;
    double tempRating = _minimumRating;
    String tempBrand = _selectedBrand;

    final brands = _getAvailableBrands();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.78,

              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),

              decoration: const BoxDecoration(
                color: Color(0xFFFAF5F3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),

              child: Column(
                children: [
                  // -------------------------------------------------
                  // HANDLE
                  // -------------------------------------------------
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // -------------------------------------------------
                  // HEADER
                  // -------------------------------------------------
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Filter products',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          setSheetState(() {
                            tempMinPrice = 0;
                            tempMaxPrice = 1000;
                            tempRating = 0;
                            tempBrand = 'All Brands';
                          });
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // =========================================
                          // PRICE
                          // =========================================
                          const Text(
                            'Price range',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Rs. ${tempMinPrice.round()} - Rs. ${tempMaxPrice.round()}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),

                          RangeSlider(
                            values: RangeValues(tempMinPrice, tempMaxPrice),
                            min: 0,
                            max: 1000,
                            divisions: 20,
                            activeColor: Colors.black,
                            inactiveColor: Colors.black12,
                            labels: RangeLabels(
                              'Rs. ${tempMinPrice.round()}',
                              'Rs. ${tempMaxPrice.round()}',
                            ),
                            onChanged: (values) {
                              setSheetState(() {
                                tempMinPrice = values.start;
                                tempMaxPrice = values.end;
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          // =========================================
                          // RATING
                          // =========================================
                          const Text(
                            'Minimum rating',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 8,
                            children: [
                              _ratingOption(
                                value: 0,
                                selected: tempRating == 0,
                                onTap: () {
                                  setSheetState(() {
                                    tempRating = 0;
                                  });
                                },
                              ),
                              _ratingOption(
                                value: 3,
                                selected: tempRating == 3,
                                onTap: () {
                                  setSheetState(() {
                                    tempRating = 3;
                                  });
                                },
                              ),
                              _ratingOption(
                                value: 4,
                                selected: tempRating == 4,
                                onTap: () {
                                  setSheetState(() {
                                    tempRating = 4;
                                  });
                                },
                              ),
                              _ratingOption(
                                value: 4.5,
                                selected: tempRating == 4.5,
                                onTap: () {
                                  setSheetState(() {
                                    tempRating = 4.5;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // =========================================
                          // BRAND
                          // =========================================
                          const Text(
                            'Brand',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: brands.map((brand) {
                              final selected = tempBrand == brand;

                              return GestureDetector(
                                onTap: () {
                                  setSheetState(() {
                                    tempBrand = brand;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: selected
                                          ? Colors.black
                                          : Colors.black12,
                                    ),
                                  ),
                                  child: Text(
                                    brand,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  // -------------------------------------------------
                  // APPLY
                  // -------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _minPrice = tempMinPrice;
                          _maxPrice = tempMaxPrice;
                          _minimumRating = tempRating;
                          _selectedBrand = tempBrand;
                        });

                        Navigator.pop(context);

                        _applyFiltersAndSort();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ===============================================================
  // RATING OPTION
  // ===============================================================

  Widget _ratingOption({
    required double value,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? Colors.black : Colors.black12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value > 0) ...[
              Icon(
                Icons.star,
                size: 15,
                color: selected ? Colors.white : Colors.amber,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              value == 0
                  ? 'All'
                  : '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}+',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
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

      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF5F3),
        elevation: 0,

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

        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            )
          : _buildProductListing(),
    );
  }

  // ===============================================================
  // PRODUCT LISTING
  // ===============================================================

  Widget _buildProductListing() {
    if (_filteredProducts.isEmpty) {
      return Column(
        children: [
          _buildFilterSortBar(),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.production_quantity_limits_outlined,
                      size: 55,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'No ${widget.categoryName} products found',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Try changing your filters.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),

                    const SizedBox(height: 18),

                    OutlinedButton(
                      onPressed: _resetFilters,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Reset Filters'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildFilterSortBar(),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${_filteredProducts.length} products found',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            physics: const BouncingScrollPhysics(),
            itemCount: _filteredProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 15,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              return _productCard(_filteredProducts[index]);
            },
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // FILTER / SORT BAR
  // ===============================================================

  Widget _buildFilterSortBar() {
    final filtersApplied =
        _minPrice > 0 ||
        _maxPrice < 1000 ||
        _minimumRating > 0 ||
        _selectedBrand != 'All Brands';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _showFilterSheet,
              child: Container(
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: filtersApplied ? Colors.black : Colors.black12,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.tune, size: 18),
                    const SizedBox(width: 7),
                    const Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (filtersApplied) ...[
                      const SizedBox(width: 5),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: GestureDetector(
              onTap: _showSortSheet,
              child: Container(
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _selectedSort != 'Relevance'
                        ? Colors.black
                        : Colors.black12,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.swap_vert, size: 19),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        _selectedSort == 'Relevance' ? 'Sort' : _selectedSort,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // PRODUCT CARD
  // ===============================================================

  Widget _productCard(CosmoProduct product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailFromApi(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // IMAGE
            // =====================================================
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFE8D7D0),
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // FAVORITE
                  Positioned(
                    top: 9,
                    right: 9,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, size: 17),
                    ),
                  ),

                  // RATING
                  Positioned(
                    left: 9,
                    bottom: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 13, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // PRODUCT INFO
            // =====================================================
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      'Rs. ${(product.price * 280).round()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
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
}
