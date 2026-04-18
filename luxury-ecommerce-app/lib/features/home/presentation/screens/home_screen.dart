import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/utils/extensions.dart';
import 'package:luxury_ecommerce/core/widgets/animated_button.dart';
import 'package:luxury_ecommerce/core/widgets/glass_card.dart';
import 'package:luxury_ecommerce/features/home/presentation/widgets/hero_section.dart';
import 'package:luxury_ecommerce/features/home/presentation/widgets/categories_grid.dart';
import 'package:luxury_ecommerce/features/home/presentation/widgets/featured_products.dart';
import 'package:luxury_ecommerce/features/home/presentation/widgets/promo_banner.dart';
import 'package:luxury_ecommerce/features/products/presentation/providers/products_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarBackground = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final showBackground = _scrollController.offset > 100;
    if (showBackground != _showAppBarBackground) {
      setState(() => _showAppBarBackground = showBackground);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final productsAsync = ref.watch(featuredProductsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: _showAppBarBackground
              ? GlassAppBar(
                  title: Text(
                    'LUXE',
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      // Open drawer or menu
                    },
                    icon: const Icon(PhosphorIcons.list),
                  ),
                  actions: [
                    AnimatedIconButton(
                      onPressed: () {
                        context.push(RouteNames.search);
                      },
                      icon: PhosphorIcons.magnifyingGlass,
                      backgroundColor: isDark ? AppColors.gray800 : AppColors.gray100,
                    ),
                    const SizedBox(width: 8),
                    AnimatedIconButton(
                      onPressed: () {
                        context.push(RouteNames.cart);
                      },
                      icon: PhosphorIcons.shoppingBag,
                      backgroundColor: isDark ? AppColors.gray800 : AppColors.gray100,
                    ),
                    const SizedBox(width: 16),
                  ],
                )
              : AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    'LUXE',
                    style: AppTypography.titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      PhosphorIcons.list,
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        PhosphorIcons.magnifyingGlass,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.push(RouteNames.cart);
                      },
                      icon: const Icon(
                        PhosphorIcons.shoppingBag,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero Section with 3D parallax
          const SliverToBoxAdapter(
            child: HeroSection(),
          ),

          // Categories Grid
          SliverToBoxAdapter(
            child: CategoriesGrid()
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 600.ms),
          ),

          // Featured Products Header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured',
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms)
                      .slideX(begin: -0.1, end: 0, delay: 600.ms),
                  TextButton(
                    onPressed: () {
                      context.push(RouteNames.productList.replaceAll(':categoryId', 'featured'));
                    },
                    child: Text(
                      'View All',
                      style: AppTypography.labelLarge.copyWith(
                        color: isDark ? AppColors.primary400 : AppColors.primary600,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 700.ms),
                ],
              ),
            ),
          ),

          // Featured Products Horizontal List
          SliverToBoxAdapter(
            child: SizedBox(
              height: 320,
              child: productsAsync.when(
                data: (products) => FeaturedProducts(products: products),
                loading: () => const _FeaturedProductsSkeleton(),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ),

          // Promo Banner
          const SliverToBoxAdapter(
            child: PromoBanner(),
          ),

          // New Arrivals Header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Arrivals',
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: AppTypography.labelLarge.copyWith(
                        color: isDark ? AppColors.primary400 : AppColors.primary600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // New Arrivals Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: productsAsync.when(
              data: (products) => SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index % products.length];
                    return _ProductCard(product: product, index: index)
                        .animate(delay: (index * 100).ms)
                        .fadeIn(duration: 400.ms)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                          duration: 400.ms,
                        );
                  },
                  childCount: 6,
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: SizedBox(height: 400, child: _ProductsGridSkeleton()),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $error')),
              ),
            ),
          ),

          // Bottom spacing
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}

class _FeaturedProductsSkeleton extends StatelessWidget {
  const _FeaturedProductsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          width: 220,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
        );
      },
    );
  }
}

class _ProductsGridSkeleton extends StatelessWidget {
  const _ProductsGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
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

class _ProductCard extends StatelessWidget {
  final dynamic product;
  final int index;

  const _ProductCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: () {
        context.push(RouteNames.productDetailPath('product_$index'));
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
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray100,
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
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      product.price.toCurrency(),
                      style: AppTypography.priceSmall.copyWith(
                        color: isDark ? AppColors.primary400 : AppColors.primary600,
                      ),
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
