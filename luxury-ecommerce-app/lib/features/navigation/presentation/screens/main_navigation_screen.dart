import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/widgets/glass_card.dart';
import 'package:luxury_ecommerce/features/cart/presentation/providers/cart_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(
      icon: PhosphorIcons.house,
      activeIcon: PhosphorIcons.houseFill,
      label: 'Home',
      route: RouteNames.home,
    ),
    _NavItem(
      icon: PhosphorIcons.gridFour,
      activeIcon: PhosphorIcons.gridFourFill,
      label: 'Categories',
      route: RouteNames.categories,
    ),
    _NavItem(
      icon: PhosphorIcons.heart,
      activeIcon: PhosphorIcons.heartFill,
      label: 'Wishlist',
      route: RouteNames.wishlist,
    ),
    _NavItem(
      icon: PhosphorIcons.package,
      activeIcon: PhosphorIcons.packageFill,
      label: 'Orders',
      route: RouteNames.orders,
    ),
    _NavItem(
      icon: PhosphorIcons.user,
      activeIcon: PhosphorIcons.userFill,
      label: 'Profile',
      route: RouteNames.profile,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIndexFromLocation();
  }

  void _updateIndexFromLocation() {
    final location = GoRouterState.of(context).uri.path;
    final index = _navItems.indexWhere((item) => item.route == location);
    if (index != -1) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartItemCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray900 : AppColors.pureWhite,
          boxShadow: AppShadows.strong,
        ),
        child: SafeArea(
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = _currentIndex == index;

                return _NavBarItem(
                  item: item,
                  isSelected: isSelected,
                  badgeCount: item.route == RouteNames.wishlist
                      ? cartItemCount
                      : null,
                  onTap: () {
                    if (_currentIndex != index) {
                      context.go(item.route);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final int? badgeCount;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.primary900.withOpacity(0.5)
                  : AppColors.primary100)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    key: ValueKey(isSelected),
                    size: 24,
                    color: isSelected
                        ? (isDark
                            ? AppColors.primary400
                            : AppColors.primary600)
                        : (isDark
                            ? AppColors.gray400
                            : AppColors.gray500),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected
                        ? (isDark
                            ? AppColors.primary400
                            : AppColors.primary600)
                        : (isDark
                            ? AppColors.gray400
                            : AppColors.gray500),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (badgeCount != null && badgeCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : '$badgeCount',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
