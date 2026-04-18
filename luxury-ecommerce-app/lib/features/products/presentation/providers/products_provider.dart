import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luxury_ecommerce/features/products/domain/models/product.dart';

// Featured products provider
final featuredProductsProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductsNotifier();
});

// Products by category provider
final productsByCategoryProvider = StateNotifierProvider.family<
    ProductsByCategoryNotifier,
    AsyncValue<List<Product>>,
    String>((ref, categoryId) {
  return ProductsByCategoryNotifier(categoryId);
});

// Single product provider
final productDetailProvider =
    FutureProvider.family<Product?, String>((ref, productId) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));
  final products = Product.getSampleProducts();
  return products.firstWhere(
    (p) => p.id == productId,
    orElse: () => products.first,
  );
});

// Categories provider
final categoriesProvider = Provider<List<Category>>((ref) {
  return Category.getSampleCategories();
});

// Products search/filter provider
final productsSearchProvider =
    StateNotifierProvider<ProductsSearchNotifier, List<Product>>((ref) {
  return ProductsSearchNotifier();
});

// Selected category provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Wishlist provider
final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<String>>((ref) {
  return WishlistNotifier();
});

// Products Notifier
class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductsNotifier() : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      final products = Product.getSampleProducts();
      state = AsyncValue.data(products);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await loadProducts();
  }
}

// Products by Category Notifier
class ProductsByCategoryNotifier
    extends StateNotifier<AsyncValue<List<Product>>> {
  final String categoryId;

  ProductsByCategoryNotifier(this.categoryId)
      : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final allProducts = Product.getSampleProducts();
      final filteredProducts = categoryId == 'all' || categoryId == 'featured'
          ? allProducts.where((p) => p.isFeatured).toList()
          : allProducts.where((p) => p.categoryId == categoryId).toList();
      state = AsyncValue.data(filteredProducts);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await loadProducts();
  }
}

// Products Search Notifier
class ProductsSearchNotifier extends StateNotifier<List<Product>> {
  ProductsSearchNotifier() : super(Product.getSampleProducts());

  void search(String query) {
    if (query.isEmpty) {
      state = Product.getSampleProducts();
      return;
    }

    final allProducts = Product.getSampleProducts();
    state = allProducts.where((product) {
      final searchLower = query.toLowerCase();
      return product.name.toLowerCase().contains(searchLower) ||
          product.description.toLowerCase().contains(searchLower) ||
          product.categoryName.toLowerCase().contains(searchLower) ||
          product.tags.any((tag) => tag.toLowerCase().contains(searchLower));
    }).toList();
  }

  void filterByPriceRange(double min, double max) {
    state = state.where((p) => p.finalPrice >= min && p.finalPrice <= max).toList();
  }

  void sortByPrice({bool ascending = true}) {
    state = [...state]..sort((a, b) => ascending
        ? a.finalPrice.compareTo(b.finalPrice)
        : b.finalPrice.compareTo(a.finalPrice));
  }

  void sortByRating({bool ascending = false}) {
    state = [...state]..sort((a, b) => ascending
        ? a.rating.compareTo(b.rating)
        : b.rating.compareTo(a.rating));
  }

  void sortByNewest() {
    state = [...state]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

// Wishlist Notifier
class WishlistNotifier extends StateNotifier<List<String>> {
  WishlistNotifier() : super([]);

  void toggle(String productId) {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
  }

  void add(String productId) {
    if (!state.contains(productId)) {
      state = [...state, productId];
    }
  }

  void remove(String productId) {
    state = state.where((id) => id != productId).toList();
  }

  bool isInWishlist(String productId) => state.contains(productId);

  void clear() {
    state = [];
  }
}

// Selected product provider for detail view
final selectedProductProvider = StateProvider<Product?>((ref) => null);

// Product quantity provider
final productQuantityProvider = StateProvider.family<int, String>((ref, productId) {
  return 1;
});
