import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/utils/extensions.dart';
import 'package:luxury_ecommerce/core/widgets/animated_button.dart';
import 'package:luxury_ecommerce/features/cart/presentation/providers/cart_provider.dart';
import 'package:luxury_ecommerce/features/products/domain/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FeaturedProducts extends StatelessWidget {
  final List<Product> products;

  const FeaturedProducts({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _FeaturedProductCard(
          product: products[index],
          index: index,
        );
      },
    );
  }
}

class _FeaturedProductCard extends ConsumerWidget {
  final Product product;
  final int index;

  const _FeaturedProductCard({
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: () {
        context.push(RouteNames.productDetailPath(product.id));
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray900 : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.medium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with New Badge
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Hero(
                    tag: 'featured_${product.id}',
                    child: Container(
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
                  ),
                  if (product.isNew)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
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
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        // Add to wishlist
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          PhosphorIcons.heart,
                          size: 18,
                          color: AppColors.gray600,
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
                padding: const EdgeInsets.all(16),
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
                      style: AppTypography.titleMedium.copyWith(
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
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            ref.read(cartProvider.notifier).addItem(product);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.primary900.withOpacity(0.5)
                                  : AppColors.primary100,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Icon(
                              PhosphorIcons.plus,
                              color: isDark
                                  ? AppColors.primary400
                                  : AppColors.primary600,
                            ),
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
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0, duration: 400.ms);
  }
}
