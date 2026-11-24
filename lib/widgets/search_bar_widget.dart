import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';

/// SearchBarWidget provides real-time search filtering for products.
class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    // Synchronize controller if search query was cleared externally
    if (provider.searchQuery.isEmpty && _controller.text.isNotEmpty) {
      _controller.clear();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.surfaceGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: provider.searchQuery.isNotEmpty
                ? AppTheme.primaryColor.withValues(alpha: 0.5)
                : const Color(0xFFEBECEF),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            // Search Icon
            const Icon(
              Icons.search_rounded,
              color: AppTheme.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 10),

            // Search Text Field
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  context.read<ProductProvider>().setSearchQuery(value);
                },
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search sneakers, brand, or apparel...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            // Clear Button when query is not empty
            if (provider.searchQuery.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppTheme.textSecondary,
                ),
                onPressed: () {
                  _controller.clear();
                  context.read<ProductProvider>().clearSearchQuery();
                },
              ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
