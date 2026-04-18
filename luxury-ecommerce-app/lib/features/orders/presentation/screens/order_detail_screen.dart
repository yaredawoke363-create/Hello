import 'package:flutter/material.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/utils/extensions.dart';
import 'package:luxury_ecommerce/core/widgets/animated_button.dart';
import 'package:luxury_ecommerce/core/widgets/glass_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
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
            // Order Header
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orderId,
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          'Delivered',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    label: 'Order Date',
                    value: 'Dec 12, 2024',
                  ),
                  _InfoRow(
                    label: 'Delivered On',
                    value: 'Dec 15, 2024',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Order Tracking
            Text(
              'Order Status',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _OrderTrackingTimeline(),

            const SizedBox(height: 24),

            // Items
            Text(
              'Items',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _OrderItemsList(),

            const SizedBox(height: 24),

            // Shipping Address
            Text(
              'Shipping Address',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '123 Luxury Avenue, Suite 500\nNew York, NY 10001\nUnited States',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '+1 (555) 123-4567',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Order Summary
            Text(
              'Order Summary',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SummaryRow(label: 'Subtotal', value: '\$1,999.00'),
                  _SummaryRow(label: 'Shipping', value: 'Free'),
                  _SummaryRow(label: 'Tax', value: '\$159.92'),
                  const Divider(height: 24),
                  _SummaryRow(
                    label: 'Total',
                    value: '\$2,158.92',
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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Download Invoice'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedButton(
                onPressed: () {},
                child: const Text('Reorder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.gray400 : AppColors.gray500,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTrackingTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      _TrackingStep(
        title: 'Order Placed',
        subtitle: 'Dec 12, 10:30 AM',
        isCompleted: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Processing',
        subtitle: 'Dec 12, 2:00 PM',
        isCompleted: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Shipped',
        subtitle: 'Dec 13, 9:00 AM',
        isCompleted: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Out for Delivery',
        subtitle: 'Dec 15, 8:00 AM',
        isCompleted: true,
        isActive: false,
      ),
      _TrackingStep(
        title: 'Delivered',
        subtitle: 'Dec 15, 2:30 PM',
        isCompleted: true,
        isActive: true,
      ),
    ];

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == steps.length - 1;

          return _TimelineItem(
            step: step,
            isLast: isLast,
          );
        }).toList(),
      ),
    );
  }
}

class _TrackingStep {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;

  _TrackingStep({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isActive,
  });
}

class _TimelineItem extends StatelessWidget {
  final _TrackingStep step;
  final bool isLast;

  const _TimelineItem({
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: step.isCompleted
                    ? AppColors.success
                    : (isDark ? AppColors.gray800 : AppColors.gray200),
                shape: BoxShape.circle,
                border: Border.all(
                  color: step.isActive
                      ? AppColors.success
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: step.isCompleted
                  ? const Icon(
                      PhosphorIcons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: step.isCompleted
                    ? AppColors.success
                    : (isDark ? AppColors.gray800 : AppColors.gray200),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: step.isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step.subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.gray400 : AppColors.gray500,
                ),
              ),
              if (!isLast) const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _OrderItemRow(
            name: 'Chronos Elite Timepiece',
            quantity: 1,
            price: 2499.00,
            imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
          ),
          const Divider(height: 24),
          _OrderItemRow(
            name: 'Executive Leather Briefcase',
            quantity: 1,
            price: 1899.00,
            imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa',
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  const _OrderItemRow({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty: $quantity',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.gray400 : AppColors.gray500,
                ),
              ),
            ],
          ),
        ),
        Text(
          price.toCurrency(),
          style: AppTypography.priceSmall.copyWith(
            color: isDark ? AppColors.primary400 : AppColors.primary600,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
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
                    color: isDark ? AppColors.gray400 : AppColors.gray500,
                  ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.priceLarge.copyWith(
                    color: isDark
                        ? AppColors.primary400
                        : AppColors.primary600,
                  )
                : AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ],
      ),
    );
  }
}
