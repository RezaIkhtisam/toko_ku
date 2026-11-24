import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toko_ku/main.dart';
import 'package:toko_ku/providers/product_provider.dart';

void main() {
  group('Toko_Ku Unit & Widget Tests', () {
    test('ProductProvider logic test: favorites, cart, search, and brand filter', () {
      final provider = ProductProvider();

      // Initial state checks
      expect(provider.allProducts.length, greaterThanOrEqualTo(10));
      expect(provider.searchQuery, isEmpty);
      expect(provider.selectedBrand, 'All');

      // 1. Search Query Test
      provider.setSearchQuery('Alphafly');
      expect(provider.filteredProducts.length, 1);
      expect(provider.filteredProducts.first.name, 'Nike Alphafly 2');
      provider.clearSearchQuery();
      expect(provider.filteredProducts.length, provider.allProducts.length);

      // 2. Brand Filter Test
      provider.setSelectedBrand('Puma');
      expect(
        provider.filteredProducts.every((p) => p.brand.toLowerCase() == 'puma'),
        isTrue,
      );
      provider.resetBrand();
      expect(provider.selectedBrand, 'All');

      // 3. Favorite Toggle Test
      final initialFavCount = provider.favoriteCount;
      const testProdId = 'prod-001';
      final isNowFav = provider.toggleFavorite(testProdId);
      expect(isNowFav, isTrue);
      expect(provider.isFavorite(testProdId), isTrue);
      expect(provider.favoriteCount, initialFavCount + 1);

      provider.toggleFavorite(testProdId);
      expect(provider.isFavorite(testProdId), isFalse);

      // 4. Cart Operations Test
      final product = provider.allProducts.first;
      expect(provider.cartTotalItemCount, 0);

      provider.addToCart(product, size: 'US 9');
      expect(provider.cartTotalItemCount, 1);
      expect(provider.cartTotalPrice, product.price);

      // Add same product size again (increments quantity)
      provider.addToCart(product, size: 'US 9');
      expect(provider.cartTotalItemCount, 2);
      expect(provider.cartTotalPrice, product.price * 2);

      // Decrement quantity
      provider.updateCartQuantity('${product.id}_US 9', -1);
      expect(provider.cartTotalItemCount, 1);

      // Clear cart
      provider.clearCart();
      expect(provider.cartTotalItemCount, 0);
      expect(provider.cartTotalPrice, 0);
    });

    testWidgets('TokoKuApp smoke and initial render test', (WidgetTester tester) async {
      await tester.pumpWidget(const TokoKuApp());
      await tester.pump();

      // Verify that the Toko_Ku title and subtitle are rendered
      expect(find.text('Toko_Ku'), findsOneWidget);
      expect(find.text('Fashion & Sneakers Store'), findsOneWidget);

      // Verify that the Today Sale! section is rendered
      expect(find.text('Today Sale!'), findsOneWidget);

      // Verify that the Search Bar is present
      expect(find.byType(TextField), findsOneWidget);

      // Verify that Bottom Navigation Bar is present
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.dashboard_outlined), findsOneWidget);
    });

    testWidgets('Promo Banner Carousel swipe test', (WidgetTester tester) async {
      await tester.pumpWidget(const TokoKuApp());
      await tester.pump();

      // Find PageView for promo banners
      final pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      // Verify first slide is visible
      expect(find.text('Converse x\nDRKSHDW'), findsOneWidget);

      // Swipe horizontally to next banner
      await tester.drag(pageViewFinder, const Offset(-400, 0));
      await tester.pump();

      // Verify second slide is now active
      expect(find.text('Nike Zoom\nAlphafly 2'), findsOneWidget);
    });

    testWidgets('Search Bar interactive typing filters product collection', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const TokoKuApp());
      await tester.pump();

      // Find the TextField and enter search query
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Samba');
      await tester.pump();

      // Verify that search results header updates
      expect(find.text('Search Results'), findsOneWidget);
      expect(find.text('Adidas Samba OG'), findsWidgets);
    });
  });
}
