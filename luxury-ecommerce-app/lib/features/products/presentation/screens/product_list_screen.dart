import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/utils/extensions.dart';
import 'package:luxury_ecommerce/core/widgets/animated_text.dart';
import 'package:luxury_ecommerce/features/products/domain/models/product.dart';
import 'package:luxury_ecommerce/features/products/presentation/providers/products_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProductListScreen extends ConsumerWidget {
  final String? categoryId;

  const ProductListScreen({super.key, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync =
        ref.watch(productsByCategoryProvider(categoryId ?? 'all'));
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getCategoryName(categoryId),
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Show filter bottom sheet
            },
            icon: const Icon(PhosphorIcons.faders),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: productsAsync.when(
        data: (products) => _ProductGrid(products: products),
        loading: () => const _ProductGridSkeleton(),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  String _getCategoryName(String? categoryId) {
    final categories = {
      'cat_1': 'Watches',
      'cat_2': 'Bags',
      'cat_3': 'Shoes',
      'cat_4': 'Accessories',
      'cat_5': 'Jewelry',
      'cat_6': 'Home',
      'featured': 'Featured',
      'all': 'All Products',
    };
    return categories[categoryId] ?? 'Products';
  }
}

class _ProductGrid extends StatelessWidget {
  final List<Product> products;

  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(product: product, index: index);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final int index;

  const _ProductCard({
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: () {
        context.push(RouteNames.productDetailPath(product.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray900 : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.card),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (product.isNew)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary600,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          'NEW',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  if (product.isOnSale)
                    Positioned(
                      top: product.isNew ? 32 : 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          '-${product.discountPercentage?.toInt()}%',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.categoryName,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.gray400 : AppColors.gray500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          product.finalPrice.toCurrency(),
                          style: AppTypography.priceSmall.copyWith(
                            color: isDark
                                ? AppColors.primary400
                                : AppColors.primary600,
                          ),
                        ),
                        if (product.isOnSale) ...[
                          const SizedBox(width: 6),
                          Text(
                            product.price.toCurrency(),
                            style: AppTypography.bodySmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: isDark
                                  ? AppColors.gray500
                                  : AppColors.gray400,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          PhosphorIcons.starFill,
                          size: 14,
                          color: AppColors.accentGold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.gray500
                                : AppColors.gray400,
                          ),
                        ),
                      ],
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

class _ProductGridSkeleton extends StatelessWidget {
  const _ProductGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
        );
      },
    );
  }
}
