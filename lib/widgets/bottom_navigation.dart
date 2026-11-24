import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';

/// BottomNavigation represents the floating dark capsule bar inspired by the reference design.
/// Stays on the single screen while updating state and providing contextual bottom sheets.
class BottomNavigation extends StatelessWidget {
  final Function(int) onTabSelected;

  const BottomNavigation({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final activeIndex = provider.activeNavIndex;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: AppTheme.bottomNavBackground,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Home Tab
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                isActive: activeIndex == 0,
                onTap: () => onTabSelected(0),
              ),

              // 2. Category Tab
              _buildNavItem(
                index: 1,
                icon: Icons.dashboard_outlined,
                isActive: activeIndex == 1,
                onTap: () => onTabSelected(1),
              ),

              // 3. Favorite Tab
              Consumer<ProductProvider>(
                builder: (context, prov, _) {
                  return _buildNavItem(
                    index: 2,
                    icon: prov.favoriteCount > 0
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    isActive: activeIndex == 2,
                    badgeCount: prov.favoriteCount,
                    onTap: () => onTabSelected(2),
                  );
                },
              ),

              // 4. Chat Tab
              _buildNavItem(
                index: 3,
                icon: Icons.chat_bubble_outline_rounded,
                isActive: activeIndex == 3,
                onTap: () => onTabSelected(3),
              ),

              // 5. Profile Tab
              _buildNavItem(
                index: 4,
                icon: Icons.person_outline_rounded,
                isActive: activeIndex == 4,
                onTap: () => onTabSelected(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? Colors.white : const Color(0xFF8B92A0),
            ),
            if (badgeCount != null && badgeCount > 0 && !isActive)
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
