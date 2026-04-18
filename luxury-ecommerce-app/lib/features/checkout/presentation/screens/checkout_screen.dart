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
import 'package:luxury_ecommerce/features/cart/presentation/providers/cart_provider.dart';
import 'package:luxury_ecommerce/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartSummary = ref.watch(cartSummaryProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Steps
            const _CheckoutProgressSteps(currentStep: 0),
            const SizedBox(height: 24),

            // Shipping Address Section
            _SectionHeader(
              icon: PhosphorIcons.mapPin,
              title: 'Shipping Address',
              onEdit: () {
                // Open address selection
              },
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'John Doe',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primary900.withOpacity(0.5)
                              : AppColors.primary100,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          'Default',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.primary400
                                : AppColors.primary700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '+1 (555) 123-4567',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '123 Luxury Avenue, Suite 500\nNew York, NY 10001\nUnited States',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.gray400 : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delivery Method Section
            _SectionHeader(
              icon: PhosphorIcons.truck,
              title: 'Delivery Method',
              onEdit: () {},
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DeliveryMethodCard(
                    title: 'Standard',
                    duration: '3-5 days',
                    price: cartSummary.subtotal > 500 ? 'Free' : '\$25.00',
                    isSelected: true,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DeliveryMethodCard(
                    title: 'Express',
                    duration: '1-2 days',
                    price: '\$45.00',
                    isSelected: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Payment Method Section
            _SectionHeader(
              icon: PhosphorIcons.creditCard,
              title: 'Payment Method',
              onEdit: () {},
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.gray800 : AppColors.gray100,
                      borderRadius: BorderRadius.circular(4),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://upload.wikimedia.org/wikipedia/commons/5/5e/Visa_Inc._logo.svg',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visa ending in 4242',
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Expires 12/25',
                          style: AppTypography.bodyMedium.copyWith(
                            color:
                                isDark ? AppColors.gray400 : AppColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    PhosphorIcons.checkCircleFill,
                    color: AppColors.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Order Summary
            _SectionHeader(
              icon: PhosphorIcons.receipt,
              title: 'Order Summary',
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _OrderSummaryRow(
                    label: 'Subtotal',
                    value: cartSummary.subtotal.toCurrency(),
                  ),
                  if (cartSummary.savings > 0)
                    _OrderSummaryRow(
                      label: 'Savings',
                      value: '-${cartSummary.savings.toCurrency()}',
                      valueColor: AppColors.success,
                    ),
                  _OrderSummaryRow(
                    label: 'Shipping',
                    value: cartSummary.shippingCost == 0
                        ? 'Free'
                        : cartSummary.shippingCost.toCurrency(),
                    valueColor:
                        cartSummary.shippingCost == 0 ? AppColors.success : null,
                  ),
                  _OrderSummaryRow(
                    label: 'Tax',
                    value: cartSummary.tax.toCurrency(),
                  ),
                  const Divider(height: 32),
                  _OrderSummaryRow(
                    label: 'Total',
                    value: cartSummary.total.toCurrency(),
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
          child: AnimatedButton(
            onPressed: () {
              context.push(RouteNames.payment);
            },
            width: double.infinity,
            child: Text('Proceed to Payment'),
          ),
        ),
      ),
    );
  }
}

class _CheckoutProgressSteps extends StatelessWidget {
  final int currentStep;

  const _CheckoutProgressSteps({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Shipping', 'Payment', 'Review'];

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  color: isActive
                      ? AppColors.primary600
                      : (Theme.of(context).brightness == Brightness.dark
                          ? AppColors.gray800
                          : AppColors.gray200),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary600 : AppColors.gray200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isActive && !isCurrent
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : Text(
                          '${index + 1}',
                          style: AppTypography.labelLarge.copyWith(
                            color: isActive ? Colors.white : AppColors.gray500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: index < currentStep
                        ? AppColors.primary600
                        : (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.gray800
                            : AppColors.gray200),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onEdit;

  const _SectionHeader({
    required this.icon,
    required this.title,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.primary400 : AppColors.primary600,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (onEdit != null)
          TextButton(
            onPressed: onEdit,
            child: Text(
              'Change',
              style: AppTypography.labelLarge.copyWith(
                color: isDark ? AppColors.primary400 : AppColors.primary600,
              ),
            ),
          ),
      ],
    );
  }
}

class _DeliveryMethodCard extends StatelessWidget {
  final String title;
  final String duration;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryMethodCard({
    required this.title,
    required this.duration,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.primary900.withOpacity(0.5)
                  : AppColors.primary100)
              : (isDark ? AppColors.gray900 : AppColors.pureWhite),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.primary400 : AppColors.primary600)
                : (isDark ? AppColors.gray800 : AppColors.gray200),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? (isDark ? AppColors.primary400 : AppColors.primary600)
                    : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              duration,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.gray400 : AppColors.gray500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: AppTypography.priceSmall.copyWith(
                color: isSelected
                    ? (isDark ? AppColors.primary400 : AppColors.primary600)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _OrderSummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    color: isDark ? AppColors.primary400 : AppColors.primary600,
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
