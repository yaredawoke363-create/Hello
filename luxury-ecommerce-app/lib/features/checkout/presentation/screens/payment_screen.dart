import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/utils/extensions.dart';
import 'package:luxury_ecommerce/core/widgets/animated_button.dart';
import 'package:luxury_ecommerce/core/widgets/glass_card.dart';
import 'package:luxury_ecommerce/features/cart/presentation/providers/cart_provider.dart';
import 'package:luxury_ecommerce/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Generate order ID
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    // Clear cart
    ref.read(cartProvider.notifier).clear();

    setState(() => _isProcessing = false);

    if (mounted) {
      context.pushReplacement(RouteNames.orderConfirmationPath(orderId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartSummary = ref.watch(cartSummaryProvider);
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
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
            // Payment Methods
            Text(
              'Payment Method',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _PaymentMethodCard(
              icon: PhosphorIcons.creditCard,
              title: 'Credit Card',
              subtitle: 'Visa ending in 4242',
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _PaymentMethodCard(
              icon: PhosphorIcons.wallet,
              title: 'Apple Pay',
              subtitle: 'Fast and secure',
              isSelected: false,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _PaymentMethodCard(
              icon: PhosphorIcons.paypalLogo,
              title: 'PayPal',
              subtitle: 'Pay with your PayPal account',
              isSelected: false,
              onTap: () {},
            ),

            const SizedBox(height: 32),

            // Card Details Form
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Information',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Card Number',
                    hint: '4242 4242 4242 4242',
                    prefixIcon: PhosphorIcons.creditCard,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Expiry',
                          hint: 'MM/YY',
                          prefixIcon: PhosphorIcons.calendar,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          label: 'CVC',
                          hint: '123',
                          prefixIcon: PhosphorIcons.lock,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Security Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIcons.shieldCheck,
                    color: AppColors.success,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your payment information is encrypted and secure. We never store your full card details.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.gray300 : AppColors.gray600,
                      ),
                    ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Payment',
                    style: AppTypography.bodyLarge.copyWith(
                      color: isDark ? AppColors.gray400 : AppColors.gray600,
                    ),
                  ),
                  Text(
                    cartSummary.total.toCurrency(),
                    style: AppTypography.priceLarge.copyWith(
                      color: isDark
                          ? AppColors.primary400
                          : AppColors.primary600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AnimatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                width: double.infinity,
                loading: _isProcessing,
                child: const Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, size: 20),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                        ? AppColors.primary400.withOpacity(0.2)
                        : AppColors.primary100)
                    : (isDark ? AppColors.gray800 : AppColors.gray100),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? (isDark ? AppColors.primary400 : AppColors.primary600)
                    : (isDark ? AppColors.gray400 : AppColors.gray500),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? (isDark
                              ? AppColors.primary400
                              : AppColors.primary600)
                          : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.primary400 : AppColors.primary600)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.primary400 : AppColors.primary600)
                      : (isDark ? AppColors.gray600 : AppColors.gray400),
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
