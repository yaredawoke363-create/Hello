import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/utils/extensions.dart';
import 'package:luxury_ecommerce/core/widgets/animated_button.dart';
import 'package:luxury_ecommerce/core/widgets/glass_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    // Sample orders data
    final orders = [
      _OrderItem(
        id: 'ORD-001',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Delivered',
        statusColor: AppColors.success,
        items: 3,
        total: 1899.00,
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
      ),
      _OrderItem(
        id: 'ORD-002',
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: 'In Transit',
        statusColor: AppColors.warning,
        items: 2,
        total: 1299.00,
        imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa',
      ),
      _OrderItem(
        id: 'ORD-003',
        date: DateTime.now().subtract(const Duration(days: 12)),
        status: 'Delivered',
        statusColor: AppColors.success,
        items: 1,
        total: 549.00,
        imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: orders.isEmpty
          ? _EmptyOrdersView()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(
                  order: order,
                  index: index,
                );
              },
            ),
    );
  }
}

class _OrderItem {
  final String id;
  final DateTime date;
  final String status;
  final Color statusColor;
  final int items;
  final double total;
  final String imageUrl;

  _OrderItem({
    required this.id,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.items,
    required this.total,
    required this.imageUrl,
  });
}

class _OrderCard extends StatelessWidget {
  final _OrderItem order;
  final int index;

  const _OrderCard({
    required this.order,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: () {
        context.push(RouteNames.orderDetailPath(order.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray900 : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Order Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      image: DecorationImage(
                        image: NetworkImage(order.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Order Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.id,
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: order.statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppRadius.xs),
                              ),
                              child: Text(
                                order.status,
                                style: AppTypography.labelSmall.copyWith(
                                  color: order.statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.date.formattedDate,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColors.gray400 : AppColors.gray500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${order.items} items',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  ),
                  Text(
                    order.total.toCurrency(),
                    style: AppTypography.priceMedium.copyWith(
                      color: isDark
                          ? AppColors.primary400
                          : AppColors.primary600,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Track order
                      },
                      child: const Text('Track Order'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Reorder
                      },
                      child: const Text('Reorder'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms);
  }
}

class _EmptyOrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.package,
            size: 80,
            color: isDark ? AppColors.gray700 : AppColors.gray300,
          ),
          const SizedBox(height: 24),
          Text(
            'No orders yet',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start shopping to see your orders here',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.gray400 : AppColors.gray500,
            ),
          ),
          const SizedBox(height: 32),
          AnimatedButton(
            onPressed: () {
              // Navigate to home
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
}
