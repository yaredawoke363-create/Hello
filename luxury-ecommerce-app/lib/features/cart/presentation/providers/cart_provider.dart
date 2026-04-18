import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:luxury_ecommerce/features/cart/domain/models/cart_item.dart';
import 'package:luxury_ecommerce/features/products/domain/models/product.dart';

// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Cart summary provider
final cartSummaryProvider = Provider<CartSummary>((ref) {
  final cartItems = ref.watch(cartProvider);
  return CartSummary.fromItems(cartItems);
});

// Cart item count provider (for badge)
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartSummaryProvider).itemCount;
});

// Is item in cart provider
final isInCartProvider = Provider.family<bool, String>((ref, productId) {
  final cart = ref.watch(cartProvider);
  return cart.any((item) => item.product.id == productId);
});

// Cart item for product provider
final cartItemForProductProvider =
    Provider.family<CartItem?, String>((ref, productId) {
  final cart = ref.watch(cartProvider);
  return cart.firstWhere(
    (item) => item.product.id == productId,
    orElse: () => null as CartItem,
  );
});

// Cart Notifier
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  static const _uuid = Uuid();

  // Add item to cart
  void addItem(Product product, {int quantity = 1, Map<String, dynamic>? options}) {
    // Check if product already in cart
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Update quantity
      final existingItem = state[existingIndex];
      updateQuantity(
        existingItem.id,
        existingItem.quantity + quantity,
      );
    } else {
      // Add new item
      final newItem = CartItem(
        id: _uuid.v4(),
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
        selectedOptions: options,
      );
      state = [...state, newItem];
    }
  }

  // Remove item from cart
  void removeItem(String cartItemId) {
    state = state.where((item) => item.id != cartItemId).toList();
  }

  // Update item quantity
  void updateQuantity(String cartItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(cartItemId);
      return;
    }

    state = state.map((item) {
      if (item.id == cartItemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  // Increment quantity
  void incrementQuantity(String cartItemId) {
    final item = state.firstWhere((i) => i.id == cartItemId);
    updateQuantity(cartItemId, item.quantity + 1);
  }

  // Decrement quantity
  void decrementQuantity(String cartItemId) {
    final item = state.firstWhere((i) => i.id == cartItemId);
    updateQuantity(cartItemId, item.quantity - 1);
  }

  // Clear cart
  void clear() {
    state = [];
  }

  // Apply promo code (would integrate with backend)
  Future<double?> applyPromoCode(String code) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Sample promo codes
    const promoCodes = {
      'WELCOME10': 0.10, // 10% off
      'LUXURY20': 0.20, // 20% off
      'VIP25': 0.25, // 25% off
    };

    return promoCodes[code.toUpperCase()];
  }

  // Get cart item by id
  CartItem? getItem(String cartItemId) {
    try {
      return state.firstWhere((item) => item.id == cartItemId);
    } catch (e) {
      return null;
    }
  }

  // Get quantity for product
  int getQuantityForProduct(String productId) {
    final item = state.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        id: '',
        product: Product.getSampleProducts().first,
        quantity: 0,
        addedAt: DateTime.now(),
      ),
    );
    return item.quantity;
  }
}
