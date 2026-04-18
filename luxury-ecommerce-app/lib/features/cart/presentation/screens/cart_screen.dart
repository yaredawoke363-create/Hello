import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/utils/extensions.dart';
import 'package:luxury_ecommerce/core/widgets/animated_button.dart';
import 'package:luxury_ecommerce/core/widgets/animated_text.dart';
import 'package:luxury_ecommerce/core/widgets/glass_card.dart';
import 'package:luxury_ecommerce/features/cart/domain/models/cart_item.dart';
import 'package:luxury_ecommerce/features/cart/presentation/providers/cart_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartSummary = ref.watch(cartSummaryProvider);
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.gray950 : AppColors.gray50,
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clear();
              },
              child: Text(
                'Clear',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _EmptyCartView()
          : CustomScrollView(
              slivers: [
                // Cart Items List
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = cartItems[index];
                        return _CartItemCard(
                          item: item,
                          index: index,
                        )
                            .animate(delay: (index * 100).ms)
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.2, end: 0, duration: 400.ms);
                      },
                      childCount: cartItems.length,
                    ),
                  ),
                ),

                // Summary Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _CartSummaryCard(summary: cartSummary),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.2, end: 0, delay: 400.ms),
                ),

                // Bottom spacing
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : _CheckoutBar(summary: cartSummary)
              .animate()
              .fadeIn(delay: 600.ms)
              .slideY(begin: 1, end: 0, delay: 600.ms),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.shoppingBag,
            size: 80,
            color: isDark ? AppColors.gray700 : AppColors.gray300,
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2.seconds, color: AppColors.accentGold.withOpacity(0.5)),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Looks like you haven\'t added anything yet',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.gray400 : AppColors.gray500,
            ),
          ),
          const SizedBox(height: 32),
          AnimatedButton(
            onPressed: () {
              context.go(RouteNames.home);
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  final CartItem item;
  final int index;

  const _CartItemCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          PhosphorIcons.trash,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) {
        ref.read(cartProvider.notifier).removeItem(item.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray900 : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.subtle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.push(RouteNames.productDetailPath(item.product.id));
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Product Image
                    Hero(
                      tag: 'cart_${item.id}',
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          image: DecorationImage(
                            image: NetworkImage(item.product.imageUrl ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.product.categoryName,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.gray400
                                  : AppColors.gray500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedPrice(
                            price: item.product.finalPrice,
                            style: AppTypography.priceSmall,
                          ),
                        ],
                      ),
                    ),

                    // Quantity Controls
                    Column(
                      children: [
                        _QuantityButton(
                          icon: PhosphorIcons.minus,
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .decrementQuantity(item.id);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '${item.quantity}',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _QuantityButton(
                          icon: PhosphorIcons.plus,
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .incrementQuantity(item.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Icon(
            icon,
            size: 16,
            color: isDark ? AppColors.gray300 : AppColors.gray600,
          ),
        ),
      ),
    );
  }
}

class _CartSummaryCard extends StatelessWidget {
  final CartSummary summary;

  const _CartSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          _SummaryRow(
            label: 'Subtotal',
            value: summary.subtotal.toCurrency(),
          ),
          if (summary.savings > 0)
            _SummaryRow(
              label: 'Savings',
              value: '-${summary.savings.toCurrency()}',
              valueColor: AppColors.success,
            ),
          _SummaryRow(
            label: 'Shipping',
            value: summary.shippingCost == 0
                ? 'Free'
                : summary.shippingCost.toCurrency(),
            valueColor: summary.shippingCost == 0 ? AppColors.success : null,
          ),
          _SummaryRow(
            label: 'Tax (8%)',
            value: summary.tax.toCurrency(),
          ),
          const Divider(height: 32),
          _SummaryRow(
            label: 'Total',
            value: summary.total.toCurrency(),
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  )
                : AppTypography.bodyLarge.copyWith(
                    color: isDark ? AppColors.gray400 : AppColors.gray600,
                  ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.priceLarge.copyWith(
                    color: valueColor ??
                        (isDark ? AppColors.primary400 : AppColors.primary600),
                  )
                : AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ??
                        (isDark ? AppColors.gray200 : AppColors.gray800),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final CartSummary summary;

  const _CheckoutBar({required this.summary});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : AppColors.pureWhite,
        boxShadow: AppShadows.strong,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  ),
                  AnimatedPrice(
                    price: summary.total,
                    style: AppTypography.priceMedium,
                  ),
                ],
              ),
            ),
            AnimatedButton(
              onPressed: () {
                context.push(RouteNames.checkout);
              },
              width: 160,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Checkout'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
