import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/brand_category.dart';
import '../widgets/interactive_sheets.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/today_sale_section.dart';

/// HomeScreen is the single main screen of Toko_Ku.
/// Adheres strictly to the single-screen requirement while delivering a rich,
/// interactive, and visually stunning e-commerce experience.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCollection() {
    _scrollController.animateTo(
      480,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final filteredList = provider.filteredProducts;
    final isSearching = provider.searchQuery.isNotEmpty;
    final isFavoriteMode = provider.activeNavIndex == 2;
    final isCategoryFiltered = provider.selectedBrand != 'All';

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Fixed Top App Header with Brand Logo, Notifications, and Cart Badge
            AppHeader(
              onCartTap: () => InteractiveSheets.showCart(context),
              onNotificationTap: () => InteractiveSheets.showNotifications(context),
            ),

            // Search Bar Widget with Real-time Filtering
            const SearchBarWidget(),

            // Main Scrollable Content Area
            Expanded(
              child: RefreshIndicator(
                color: AppTheme.primaryColor,
                onRefresh: () async {
                  provider.clearSearchQuery();
                  provider.resetBrand();
                  provider.setActiveNavIndex(0);
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Only show Banner, Categories & Today Sale when not strictly in search/favorite mode
                      if (!isSearching && !isFavoriteMode) ...[
                        // 1. Promotional Hero Banner
                        PromoBanner(
                          onProductTap: (product) =>
                              InteractiveSheets.showProductDetail(context, product),
                        ),

                        const SizedBox(height: 12),

                        // 2. Brand Categories (Horizontal Scroll)
                        const BrandCategory(),

                        const SizedBox(height: 14),

                        // 3. Today Sale Section (with Live Countdown Timer)
                        TodaySaleSection(
                          onProductTap: (product) =>
                              InteractiveSheets.showProductDetail(context, product),
                          onSeeMoreTap: _scrollToCollection,
                        ),

                        const SizedBox(height: 20),
                      ],

                      // 4. Product Collection Section Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getCollectionTitle(
                                    isFavoriteMode,
                                    isSearching,
                                    isCategoryFiltered,
                                    provider.selectedBrand,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${filteredList.length} products available',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),

                            // Reset/Clear filter button if filtered
                            if (isSearching || isCategoryFiltered || isFavoriteMode)
                              TextButton.icon(
                                onPressed: () {
                                  provider.clearSearchQuery();
                                  provider.resetBrand();
                                  provider.setActiveNavIndex(0);
                                },
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 16,
                                  color: AppTheme.primaryColor,
                                ),
                                label: const Text(
                                  'Show All',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 5. Product Collection GridView or Empty State
                      if (filteredList.isEmpty)
                        _buildEmptyState(context, provider, isFavoriteMode)
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.63,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredList[index];
                              return ProductCard(
                                product: product,
                                onTap: () => InteractiveSheets.showProductDetail(
                                  context,
                                  product,
                                ),
                              );
                            },
                          ),
                        ),

                      // Bottom spacing so bottom navigation doesn't block content
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Fixed Bottom Navigation Bar
      bottomNavigationBar: BottomNavigation(
        onTabSelected: (index) => _handleBottomNavTap(context, provider, index),
      ),
    );
  }

  String _getCollectionTitle(
    bool isFavoriteMode,
    bool isSearching,
    bool isCategoryFiltered,
    String brand,
  ) {
    if (isFavoriteMode) return 'My Favorite Wishlist';
    if (isSearching) return 'Search Results';
    if (isCategoryFiltered) return '$brand Collection';
    return 'Recommended For You';
  }

  Widget _buildEmptyState(
    BuildContext context,
    ProductProvider provider,
    bool isFavoriteMode,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFavoriteMode
                  ? Icons.favorite_border_rounded
                  : Icons.search_off_rounded,
              size: 48,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isFavoriteMode
                ? 'No favorites yet'
                : 'No matching products found',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isFavoriteMode
                ? 'Tap the heart icon on any sneaker to add it to your wishlist.'
                : 'Try adjusting your search query or selecting a different brand.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              provider.clearSearchQuery();
              provider.resetBrand();
              provider.setActiveNavIndex(0);
            },
            child: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(
    BuildContext context,
    ProductProvider provider,
    int index,
  ) {
    switch (index) {
      case 0: // Home
        provider.setActiveNavIndex(0);
        provider.clearSearchQuery();
        provider.resetBrand();
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        break;

      case 1: // Category
        provider.setActiveNavIndex(0);
        // Scroll smoothly to brand category
        _scrollController.animateTo(
          200,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih kategori brand di atas untuk memfilter produk.'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.bottomNavBackground,
          ),
        );
        break;

      case 2: // Favorite Wishlist
        provider.setActiveNavIndex(2);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Menampilkan ${provider.favoriteCount} produk favorit kamu.',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.bottomNavBackground,
          ),
        );
        break;

      case 3: // Chat Support
        InteractiveSheets.showChatSupport(context);
        break;

      case 4: // Profile
        InteractiveSheets.showProfile(context);
        break;
    }
  }
}
