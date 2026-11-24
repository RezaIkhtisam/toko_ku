import 'package:flutter/material.dart';

/// ProductModel represents a fashion or sneaker product in the Toko_Ku marketplace.
class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String subtitle;
  final double price;
  final double? originalPrice;
  final int? discountPercent;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final List<String> sizes;
  final List<Color> colors;
  final bool isTodaySale;
  final bool isFeatured;
  final String colorNote;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.subtitle,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.description,
    this.sizes = const ['US 7.5', 'US 8', 'US 8.5', 'US 9', 'US 10', 'US 11'],
    this.colors = const [Colors.black, Colors.white, Color(0xFFFF4B26)],
    this.isTodaySale = false,
    this.isFeatured = false,
    this.colorNote = '1 Colour',
  });

  /// Check whether this product has an active discount
  bool get hasDiscount =>
      originalPrice != null && originalPrice! > price && discountPercent != null;

  /// Helper to calculate discount savings amount
  double get savingsAmount =>
      (originalPrice != null && originalPrice! > price)
          ? (originalPrice! - price)
          : 0;
}

/// CartItem represents an item added to the user's shopping cart.
class CartItem {
  final Product product;
  int quantity;
  final String selectedSize;
  final Color selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get totalPrice => product.price * quantity;
}
