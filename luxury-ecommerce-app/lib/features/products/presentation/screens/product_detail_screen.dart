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
import 'package:luxury_ecommerce/features/products/domain/models/product.dart';
import 'package:luxury_ecommerce/features/products/presentation/providers/products_provider.dart';
import 'package:luxury_ecommerce/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.gray950 : AppColors.gray50,
      body: productAsync.when(
        data: (product) => product != null
            ? _ProductContent(
                product: product,
                selectedImageIndex: _selectedImageIndex,
                onImageSelected: (index) => setState(() => _selectedImageIndex = index),
                quantity: _quantity,
                onQuantityChanged: (qty) => setState(() => _quantity = qty),
              )
            : const _ProductNotFoundView(),
        loading: () => const _ProductDetailSkeleton(),
        error: (error, stack) => _ErrorView(error: error.toString()),
      ),
    );
  }
}

class _ProductContent extends StatelessWidget {
  final Product product;
  final int selectedImageIndex;
  final ValueChanged<int> onImageSelected;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const _ProductContent({
    required this.product,
    required this.selectedImageIndex,
    required this.onImageSelected,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'product_${product.id}',
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Main Image
                  Image.network(
                    product.images.isNotEmpty
                        ? product.images[selectedImageIndex]
                        : product.imageUrl ?? '',
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          isDark
                              ? AppColors.gray950
                              : AppColors.gray50,
                        ],
                        stops: const [0, 0.5, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(PhosphorIcons.arrowLeft),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: Consumer(
                  builder: (context, ref, child) {
                    final isWishlisted = ref
                        .watch(isInWishlistProvider(product.id));
                    return IconButton(
                      onPressed: () {
                        ref
                            .read(wishlistProvider.notifier)
                            .toggle(product.id);
                      },
                      icon: Icon(
                        isWishlisted
                            ? PhosphorIcons.heartFill
                            : PhosphorIcons.heart,
                        color: isWishlisted ? AppColors.error : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),

        // Image Thumbnails
        if (product.images.length > 1)
          SliverToBoxAdapter(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedImageIndex;
                  return GestureDetector(
                    onTap: () => onImageSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: isSelected
                              ? (isDark
                                  ? AppColors.primary400
                                  : AppColors.primary600)
                              : Colors.transparent,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(product.images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

        // Product Info
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary900.withOpacity(0.5)
                        : AppColors.primary100,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Text(
                    product.categoryName,
                    style: AppTypography.labelMedium.copyWith(
                      color: isDark
                          ? AppColors.primary400
                          : AppColors.primary700,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  product.name,
                  style: AppTypography.headlineLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                // Rating
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < product.rating.floor()
                            ? PhosphorIcons.starFill
                            : PhosphorIcons.star,
                        size: 18,
                        color: AppColors.accentGold,
                      );
                    }),
                    const SizedBox(width: 8),
                    Text(
                      '${product.rating}',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${product.reviewCount} reviews)',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.gray400 : AppColors.gray500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Price
                Row(
                  children: [
                    AnimatedPrice(
                      price: product.finalPrice,
                      style: AppTypography.priceLarge.copyWith(
                        color: isDark
                            ? AppColors.primary400
                            : AppColors.primary600,
                      ),
                    ),
                    if (product.isOnSale) ...[
                      const SizedBox(width: 12),
                      Text(
                        product.price.toCurrency(),
                        style: AppTypography.bodyLarge.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color:
                              isDark ? AppColors.gray500 : AppColors.gray400,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          '-${product.discountPercentage?.toInt()}%',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  'Description',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: AppTypography.bodyLarge.copyWith(
                    color: isDark ? AppColors.gray300 : AppColors.gray600,
                  ),
                ),

                const SizedBox(height: 24),

                // Tags
                if (product.tags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: isDark
                            ? AppColors.gray800
                            : AppColors.gray100,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Bottom spacing
        const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
      ],
    );
  }
}

class _ProductDetailSkeleton extends StatelessWidget {
  const _ProductDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          flexibleSpace: Container(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 24,
                  color: Colors.grey.withOpacity(0.2),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.grey.withOpacity(0.2),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 150,
                  height: 20,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductNotFoundView extends StatelessWidget {
  const _ProductNotFoundView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIcons.package,
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'Product Not Found',
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'The product you\'re looking for doesn\'t exist',
            style: AppTypography.bodyLarge,
          ),
          const SizedBox(height: 24),
          AnimatedButton(
            onPressed: () => context.go(RouteNames.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIcons.warningCircle,
            size: 80,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Product',
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTypography.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
