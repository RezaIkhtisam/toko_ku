import 'package:flutter/material.dart';
import '../data/dummy_products.dart';
import '../models/product_model.dart';

/// ProductProvider manages all state for Toko_Ku:
/// - Products catalog and filtering
/// - Search query
/// - Active brand category
/// - Favorite products
/// - Shopping cart and quantities
/// - Bottom navigation state
class ProductProvider extends ChangeNotifier {
  // Master list of products
  final List<Product> _products = List.from(DummyProducts.products);

  // Filter and search states
  String _searchQuery = '';
  String _selectedBrand = 'All';

  // Favorites state: Set of product IDs for fast O(1) lookups
  final Set<String> _favoriteIds = {'prod-002', 'prod-005'}; // Pre-populate some favorites

  // Shopping cart state: Map of cart item key -> CartItem
  final Map<String, CartItem> _cart = {};

  // Bottom navigation active index
  int _activeNavIndex = 0;

  // Unread notifications count
  int _notificationCount = 1;

  // --- Getters ---

  List<Product> get allProducts => List.unmodifiable(_products);

  String get searchQuery => _searchQuery;

  String get selectedBrand => _selectedBrand;

  int get activeNavIndex => _activeNavIndex;

  int get notificationCount => _notificationCount;

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  int get favoriteCount => _favoriteIds.length;

  /// Returns whether a product is currently favorited
  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  /// List of products currently favorited
  List<Product> get favoriteProducts =>
      _products.where((p) => _favoriteIds.contains(p.id)).toList();

  /// Products highlighted in Today's Sale section
  List<Product> get todaySaleProducts =>
      _products.where((p) => p.isTodaySale).toList();

  /// Hero featured product for banner
  Product get featuredProduct =>
      _products.firstWhere((p) => p.isFeatured, orElse: () => _products.first);

  /// Cart items list
  List<CartItem> get cartItems => _cart.values.toList();

  /// Total count of individual items in the cart (for badge display)
  int get cartTotalItemCount =>
      _cart.values.fold(0, (sum, item) => sum + item.quantity);

  /// Total price of all items in cart
  double get cartTotalPrice =>
      _cart.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Filtered product collection based on Search Query, Selected Brand,
  /// and whether the user is in Favorite mode (from bottom nav).
  List<Product> get filteredProducts {
    List<Product> list = _products;

    // If active nav index is 2 (Favorite icon), show favorite products
    if (_activeNavIndex == 2) {
      list = list.where((p) => _favoriteIds.contains(p.id)).toList();
    }

    // Filter by Brand Category
    if (_selectedBrand != 'All') {
      list = list
          .where((p) =>
              p.brand.toLowerCase() == _selectedBrand.toLowerCase())
          .toList();
    }

    // Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      list = list.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.subtitle.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  // --- State Mutation Methods ---

  /// Update search query and notify listeners
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  /// Clear search query
  void clearSearchQuery() {
    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      notifyListeners();
    }
  }

  /// Change selected brand filter
  void setSelectedBrand(String brand) {
    if (_selectedBrand != brand) {
      _selectedBrand = brand;
      notifyListeners();
    }
  }

  /// Reset brand filter to All
  void resetBrand() {
    if (_selectedBrand != 'All') {
      _selectedBrand = 'All';
      notifyListeners();
    }
  }

  /// Toggle favorite status of a product
  bool toggleFavorite(String productId) {
    bool isNowFav;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      isNowFav = false;
    } else {
      _favoriteIds.add(productId);
      isNowFav = true;
    }
    notifyListeners();
    return isNowFav;
  }

  /// Add product to cart with chosen size & color
  void addToCart(Product product, {String? size, Color? color}) {
    final chosenSize = size ?? (product.sizes.isNotEmpty ? product.sizes.first : 'Standard');
    final chosenColor = color ?? (product.colors.isNotEmpty ? product.colors.first : Colors.black);
    final cartKey = '${product.id}_$chosenSize';

    if (_cart.containsKey(cartKey)) {
      _cart[cartKey]!.quantity += 1;
    } else {
      _cart[cartKey] = CartItem(
        product: product,
        quantity: 1,
        selectedSize: chosenSize,
        selectedColor: chosenColor,
      );
    }
    notifyListeners();
  }

  /// Remove item from cart
  void removeFromCart(String cartKey) {
    if (_cart.containsKey(cartKey)) {
      _cart.remove(cartKey);
      notifyListeners();
    }
  }

  /// Update quantity for cart item
  void updateCartQuantity(String cartKey, int delta) {
    if (_cart.containsKey(cartKey)) {
      final current = _cart[cartKey]!;
      final newQty = current.quantity + delta;
      if (newQty <= 0) {
        _cart.remove(cartKey);
      } else {
        current.quantity = newQty;
      }
      notifyListeners();
    }
  }

  /// Clear the entire cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /// Set active bottom navigation index
  void setActiveNavIndex(int index) {
    if (_activeNavIndex != index) {
      _activeNavIndex = index;
      notifyListeners();
    }
  }

  /// Mark notifications as read
  void clearNotifications() {
    if (_notificationCount > 0) {
      _notificationCount = 0;
      notifyListeners();
    }
  }

  /// Format Indonesian Rupiah currency string (e.g. "Rp 2.850.000")
  static String formatCurrency(double amount) {
    final int intAmount = amount.round();
    final String str = intAmount.toString();
    final StringBuffer buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    final reversed = buffer.toString().split('').reversed.join('');
    return 'Rp $reversed';
  }
}
