class RouteNames {
  RouteNames._();

  // Splash & Onboarding
  static const String splash = '/';
  static const String welcome = '/welcome';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main
  static const String home = '/';
  static const String categories = '/categories';
  static const String wishlist = '/wishlist';
  static const String orders = '/orders';
  static const String profile = '/profile';

  // Products
  static const String productList = '/products/category/:categoryId';
  static const String productDetail = '/product/:productId';
  static const String search = '/search';

  // Cart & Checkout
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String orderConfirmation = '/order-confirmation/:orderId';

  // Orders
  static const String orderDetail = '/order/:orderId';

  // Profile
  static const String settings = '/settings';
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String editProfile = '/edit-profile';
  static const String notifications = '/notifications';

  // Helper methods
  static String productDetailPath(String productId) => '/product/$productId';
  static String productListPath(String categoryId) =
      '/products/category/$categoryId';
  static String orderDetailPath(String orderId) => '/order/$orderId';
  static String orderConfirmationPath(String orderId) =
      '/order-confirmation/$orderId';
}
