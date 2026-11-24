import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_products.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';

/// BrandCategory displays the horizontal brand category list
/// with custom-drawn logos matching the reference screenshot.
class BrandCategory extends StatelessWidget {
  const BrandCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final selectedBrand = provider.selectedBrand;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal Brand Category ListView
        SizedBox(
          height: 98,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: DummyProducts.brands.length,
            separatorBuilder: (context, index) => const SizedBox(width: 18),
            itemBuilder: (context, index) {
              final brand = DummyProducts.brands[index];
              final brandName = brand['name']!;
              final displayName = brand['displayName']!;
              final isSelected = selectedBrand.toLowerCase() == brandName.toLowerCase();

              return GestureDetector(
                onTap: () {
                  context.read<ProductProvider>().setSelectedBrand(brandName);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circular Brand Avatar/Button
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppTheme.primaryLight
                            : AppTheme.surfaceGrey,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : const Color(0xFFE5E7EB),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: _buildBrandLogo(brandName, isSelected),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Brand Label Text
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds recognizable brand logos matching the reference design
  Widget _buildBrandLogo(String brandName, bool isSelected) {
    final color = isSelected ? AppTheme.primaryColor : AppTheme.textPrimary;

    switch (brandName) {
      case 'All':
        return Icon(
          Icons.grid_view_rounded,
          color: color,
          size: 24,
        );

      case 'Nike':
        return CustomPaint(
          size: const Size(28, 14),
          painter: _NikeSwooshPainter(color: color),
        );

      case 'Adidas':
        return CustomPaint(
          size: const Size(26, 20),
          painter: _AdidasStripesPainter(color: color),
        );

      case 'Puma':
        return Icon(
          Icons.pets_rounded,
          color: color,
          size: 22,
        );

      case 'NB':
        return Text(
          'NB',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: -1.0,
            color: color,
          ),
        );

      case 'Converse':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rate_rounded,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 1),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: color,
            ),
          ],
        );

      case 'Jordan':
        return Text(
          '23',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: -1.0,
            color: color,
          ),
        );

      case 'Vans':
        return Text(
          'VANS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: color,
          ),
        );

      case 'Asics':
        return Text(
          'asics',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            fontStyle: FontStyle.italic,
            color: color,
          ),
        );

      case 'Reebok':
        return Icon(
          Icons.change_history_rounded,
          color: color,
          size: 22,
        );

      default:
        return Icon(Icons.sell_rounded, color: color, size: 20);
    }
  }
}

/// Custom painter for Nike Swoosh logo
class _NikeSwooshPainter extends CustomPainter {
  final Color color;
  _NikeSwooshPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.45);
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 1.15,
      size.width * 0.98,
      0,
    );
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.75,
      size.width * 0.28,
      size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.12,
      size.height * 0.45,
      0,
      size.height * 0.45,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NikeSwooshPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Custom painter for Adidas 3-Stripes logo
class _AdidasStripesPainter extends CustomPainter {
  final Color color;
  _AdidasStripesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw three slanted stripes of increasing height
    final double stripeWidth = size.width * 0.22;
    final double spacing = size.width * 0.12;

    // Stripe 1 (Shortest)
    _drawSlantedBar(canvas, paint, 0, size.height * 0.65, stripeWidth, size.height * 0.35);

    // Stripe 2 (Medium)
    _drawSlantedBar(
      canvas,
      paint,
      stripeWidth + spacing,
      size.height * 0.35,
      stripeWidth,
      size.height * 0.65,
    );

    // Stripe 3 (Tallest)
    _drawSlantedBar(
      canvas,
      paint,
      (stripeWidth + spacing) * 2,
      size.height * 0.05,
      stripeWidth,
      size.height * 0.95,
    );
  }

  void _drawSlantedBar(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double w,
    double h,
  ) {
    final path = Path();
    const double slant = 4.0;
    path.moveTo(x + slant, y);
    path.lineTo(x + w + slant, y);
    path.lineTo(x + w, y + h);
    path.lineTo(x, y + h);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AdidasStripesPainter oldDelegate) =>
      oldDelegate.color != color;
}
