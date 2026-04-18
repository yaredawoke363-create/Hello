import 'package:equatable/equatable.dart';
import 'package:luxury_ecommerce/features/products/domain/models/product.dart';

class CartItem extends Equatable {
  final String id;
  final Product product;
  final int quantity;
  final DateTime addedAt;
  final Map<String, dynamic>? selectedOptions;

  const CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    required this.addedAt,
    this.selectedOptions,
  });

  // Calculate subtotal
  double get subtotal => product.finalPrice * quantity;

  // Calculate savings
  double get savings => product.isOnSale ? product.savingsAmount * quantity : 0;

  // Factory constructor from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
      selectedOptions: json['selectedOptions'] as Map<String, dynamic>?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
      'selectedOptions': selectedOptions,
    };
  }

  // Copy with
  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    DateTime? addedAt,
    Map<String, dynamic>? selectedOptions,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  @override
  List<Object?> get props => [id, product.id, quantity];
}

class CartSummary extends Equatable {
  final int itemCount;
  final int uniqueItemCount;
  final double subtotal;
  final double savings;
  final double shippingCost;
  final double tax;
  final double total;
  final bool hasItems;

  const CartSummary({
    this.itemCount = 0,
    this.uniqueItemCount = 0,
    this.subtotal = 0,
    this.savings = 0,
    this.shippingCost = 0,
    this.tax = 0,
    this.total = 0,
    this.hasItems = false,
  });

  // Calculate from cart items
  factory CartSummary.fromItems(List<CartItem> items, {double taxRate = 0.08}) {
    final itemCount = items.fold(0, (sum, item) => sum + item.quantity);
    final subtotal = items.fold(0.0, (sum, item) => sum + item.subtotal);
    final savings = items.fold(0.0, (sum, item) => sum + item.savings);

    // Free shipping over $500
    final shippingCost = subtotal > 500 ? 0.0 : 25.0;

    // Calculate tax
    final taxableAmount = subtotal - savings;
    final tax = taxableAmount * taxRate;

    return CartSummary(
      itemCount: itemCount,
      uniqueItemCount: items.length,
      subtotal: subtotal,
      savings: savings,
      shippingCost: shippingCost,
      tax: tax,
      total: subtotal - savings + shippingCost + tax,
      hasItems: items.isNotEmpty,
    );
  }

  @override
  List<Object?> get props => [
        itemCount,
        uniqueItemCount,
        subtotal,
        savings,
        shippingCost,
        tax,
        total,
        hasItems,
      ];
}
