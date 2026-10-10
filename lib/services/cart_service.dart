import '../models/cosmo_product.dart';

class CartItem {
  final CosmoProduct product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice {
    return product.price * quantity;
  }
}

class CartService {
  // =========================
  // CART
  // =========================

  static final List<CartItem> _cartItems = [];

  static List<CartItem> get cartItems {
    return List.unmodifiable(_cartItems);
  }

  static void addToCart(CosmoProduct product) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
  }

  static void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
  }

  static void increaseQuantity(int productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      _cartItems[index].quantity++;
    }
  }

  static void decreaseQuantity(int productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
    }
  }

  static void clearCart() {
    _cartItems.clear();
  }

  static int get itemCount {
    return _cartItems.length;
  }

  static int get totalQuantity {
    return _cartItems.fold(0, (total, item) => total + item.quantity);
  }

  static double get totalPrice {
    return _cartItems.fold(0, (total, item) => total + item.totalPrice);
  }

  // =========================
  // WISHLIST
  // =========================

  static final List<CosmoProduct> _wishlist = [];

  static List<CosmoProduct> get wishlist {
    return List.unmodifiable(_wishlist);
  }

  static void addToWishlist(CosmoProduct product) {
    final exists = _wishlist.any((item) => item.id == product.id);

    if (!exists) {
      _wishlist.add(product);
    }
  }

  static void removeFromWishlist(int productId) {
    _wishlist.removeWhere((product) => product.id == productId);
  }

  static bool isInWishlist(int productId) {
    return _wishlist.any((product) => product.id == productId);
  }

  static bool toggleWishlist(CosmoProduct product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
      return false;
    }

    addToWishlist(product);
    return true;
  }

  static void clearWishlist() {
    _wishlist.clear();
  }

  static int get wishlistCount {
    return _wishlist.length;
  }
}
