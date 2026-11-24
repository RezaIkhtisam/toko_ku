import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

/// Model representing a single campaign banner in the slider carousel
class PromoCampaign {
  final String id;
  final String title;
  final String description;
  final String discountTag;
  final String buttonText;
  final List<Color> gradientColors;
  final String productId;
  final String imageUrl;

  const PromoCampaign({
    required this.id,
    required this.title,
    required this.description,
    required this.discountTag,
    required this.buttonText,
    required this.gradientColors,
    required this.productId,
    required this.imageUrl,
  });
}

/// PromoBanner displays an interactive auto-sliding and swipeable
/// promotional carousel with page indicators and multiple campaign cards.
class PromoBanner extends StatefulWidget {
  final Function(Product) onProductTap;

  const PromoBanner({
    super.key,
    required this.onProductTap,
  });

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  // 4 Curated promotional campaigns
  final List<PromoCampaign> _campaigns = const [
    PromoCampaign(
      id: 'camp-1',
      title: 'Converse x\nDRKSHDW',
      description: 'Fashion Designer Rick Owens distorts and reshapes an icon',
      discountTag: '25% OFF',
      buttonText: 'Shop Now',
      gradientColors: [
        Color(0xFFFF4B26), // Coral-orange signature
        Color(0xFFFF6238),
        Color(0xFFFF7A4D),
      ],
      productId: 'prod-001',
      imageUrl:
          'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?auto=format&fit=crop&w=800&q=80',
    ),
    PromoCampaign(
      id: 'camp-2',
      title: 'Nike Zoom\nAlphafly 2',
      description: 'Supercharged racing energy with dual Zoom Air pods',
      discountTag: '18% OFF',
      buttonText: 'Claim Deal',
      gradientColors: [
        Color(0xFF0F172A), // Midnight Dark Navy & Cyan
        Color(0xFF1E293B),
        Color(0xFF0284C7),
      ],
      productId: 'prod-002',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
    ),
    PromoCampaign(
      id: 'camp-3',
      title: 'Air Jordan 1\nRetro High',
      description: 'Iconic hardwood heritage with legendary OG color blocking',
      discountTag: '21% OFF',
      buttonText: 'Explore',
      gradientColors: [
        Color(0xFF7F1D1D), // Crimson Red & Dark Maroon
        Color(0xFFB91C1C),
        Color(0xFFDC2626),
      ],
      productId: 'prod-013',
      imageUrl:
          'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?auto=format&fit=crop&w=800&q=80',
    ),
    PromoCampaign(
      id: 'camp-4',
      title: 'Adidas\nUltraboost',
      description: 'Lightest BOOST foam engineered for infinite energy return',
      discountTag: '24% OFF',
      buttonText: 'Shop Sale',
      gradientColors: [
        Color(0xFF1E3A8A), // Royal Sport Blue
        Color(0xFF2563EB),
        Color(0xFF3B82F6),
      ],
      productId: 'prod-004',
      imageUrl:
          'https://images.unsplash.com/photo-1587563871167-1ee9c731aefb?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _campaigns.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    // Cancel timer and controller to prevent memory leaks
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          // Swipeable Carousel Container
          SizedBox(
            height: 195,
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: _campaigns.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final campaign = _campaigns[index];
                return _buildBannerCard(context, campaign, provider);
              },
            ),
          ),

          const SizedBox(height: 10),

          // Animated Carousel Page Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_campaigns.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: isActive ? 24 : 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFFF4B26)
                      : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(
    BuildContext context,
    PromoCampaign campaign,
    ProductProvider provider,
  ) {
    final linkedProduct = provider.allProducts.firstWhere(
      (p) => p.id == campaign.productId,
      orElse: () => provider.allProducts.first,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: campaign.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: campaign.gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Decorative background circles for visual depth
            Positioned(
              top: -30,
              right: 80,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: -20,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
              ),
            ),

            // Top-right Discount Badge Pill
            Positioned(
              top: 16,
              right: 18,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_offer_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          campaign.discountTag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),

            // Sneaker Product Image Showcase Container on the right
            Positioned(
              right: 14,
              bottom: 16,
              top: 48,
              width: 135,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    campaign.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.sports_basketball_rounded,
                          size: 54,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Text Content & Action Button on the left
            Positioned(
              left: 20,
              top: 18,
              bottom: 18,
              right: 165,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                          letterSpacing: -0.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        campaign.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // Call-to-action Button ("Shop Now", "Claim Deal", etc.)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onProductTap(linkedProduct),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111418), // Dark pill
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              campaign.buttonText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
