import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// Checkout state
class CheckoutState {
  final String? orderId;
  final String? shippingAddressId;
  final String? paymentMethodId;
  final String? selectedDeliveryMethod;
  final String? promoCode;
  final double? discountAmount;
  final bool isProcessing;
  final String? error;

  const CheckoutState({
    this.orderId,
    this.shippingAddressId,
    this.paymentMethodId,
    this.selectedDeliveryMethod,
    this.promoCode,
    this.discountAmount,
    this.isProcessing = false,
    this.error,
  });

  CheckoutState copyWith({
    String? orderId,
    String? shippingAddressId,
    String? paymentMethodId,
    String? selectedDeliveryMethod,
    String? promoCode,
    double? discountAmount,
    bool? isProcessing,
    String? error,
  }) {
    return CheckoutState(
      orderId: orderId ?? this.orderId,
      shippingAddressId: shippingAddressId ?? this.shippingAddressId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      selectedDeliveryMethod:
          selectedDeliveryMethod ?? this.selectedDeliveryMethod,
      promoCode: promoCode ?? this.promoCode,
      discountAmount: discountAmount ?? this.discountAmount,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
    );
  }
}

// Checkout provider
final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier();
});

// Checkout notifier
class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier() : super(const CheckoutState());

  final _uuid = const Uuid();

  void setShippingAddress(String addressId) {
    state = state.copyWith(shippingAddressId: addressId);
  }

  void setPaymentMethod(String paymentMethodId) {
    state = state.copyWith(paymentMethodId: paymentMethodId);
  }

  void setDeliveryMethod(String method) {
    state = state.copyWith(selectedDeliveryMethod: method);
  }

  Future<bool> applyPromoCode(String code) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    const validCodes = {
      'WELCOME10': 0.10,
      'LUXURY20': 0.20,
      'VIP25': 0.25,
    };

    final discount = validCodes[code.toUpperCase()];
    if (discount != null) {
      state = state.copyWith(
        promoCode: code,
        discountAmount: discount,
      );
      return true;
    }
    return false;
  }

  void removePromoCode() {
    state = state.copyWith(
      promoCode: null,
      discountAmount: null,
    );
  }

  Future<String?> processPayment({
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      state = state.copyWith(isProcessing: true, error: null);

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Generate order ID
      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      state = state.copyWith(
        isProcessing: false,
        orderId: orderId,
      );

      return orderId;
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
      return null;
    }
  }

  void reset() {
    state = const CheckoutState();
  }
}
