import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/router/transitions.dart';
import 'package:luxury_ecommerce/features/auth/presentation/screens/login_screen.dart';
import 'package:luxury_ecommerce/features/auth/presentation/screens/register_screen.dart';
import 'package:luxury_ecommerce/features/auth/presentation/screens/welcome_screen.dart';
import 'package:luxury_ecommerce/features/cart/presentation/screens/cart_screen.dart';
import 'package:luxury_ecommerce/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:luxury_ecommerce/features/checkout/presentation/screens/payment_screen.dart';
import 'package:luxury_ecommerce/features/checkout/presentation/screens/order_confirmation_screen.dart';
import 'package:luxury_ecommerce/features/home/presentation/screens/home_screen.dart';
import 'package:luxury_ecommerce/features/navigation/presentation/screens/main_navigation_screen.dart';
import 'package:luxury_ecommerce/features/orders/presentation/screens/order_detail_screen.dart';
import 'package:luxury_ecommerce/features/orders/presentation/screens/orders_screen.dart';
import 'package:luxury_ecommerce/features/products/presentation/screens/category_screen.dart';
import 'package:luxury_ecommerce/features/products/presentation/screens/product_detail_screen.dart';
import 'package:luxury_ecommerce/features/products/presentation/screens/product_list_screen.dart';
import 'package:luxury_ecommerce/features/profile/presentation/screens/profile_screen.dart';
import 'package:luxury_ecommerce/features/profile/presentation/screens/settings_screen.dart';
import 'package:luxury_ecommerce/features/wishlist/presentation/screens/wishlist_screen.dart';
import 'package:luxury_ecommerce/features/splash/presentation/screens/splash_screen.dart';

// Router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => AppTransitions.fadeScreen(
          child: const SplashScreen(),
          state: state,
        ),
      ),

      // Welcome (Onboarding)
      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        pageBuilder: (context, state) => AppTransitions.fadeScreen(
          child: const WelcomeScreen(),
          state: state,
        ),
      ),

      // Auth
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          child: const LoginScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          child: const RegisterScreen(),
          state: state,
        ),
      ),

      // Main Navigation Shell (Bottom Nav)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainNavigationScreen(child: child);
        },
        routes: [
          // Home
          GoRoute(
            path: RouteNames.home,
            name: 'home',
            pageBuilder: (context, state) => AppTransitions.fadeScreen(
              child: const HomeScreen(),
              state: state,
            ),
          ),

          // Categories (Products tab)
          GoRoute(
            path: RouteNames.categories,
            name: 'categories',
            pageBuilder: (context, state) => AppTransitions.fadeScreen(
              child: const CategoryScreen(),
              state: state,
            ),
          ),

          // Wishlist
          GoRoute(
            path: RouteNames.wishlist,
            name: 'wishlist',
            pageBuilder: (context, state) => AppTransitions.fadeScreen(
              child: const WishlistScreen(),
              state: state,
            ),
          ),

          // Orders
          GoRoute(
            path: RouteNames.orders,
            name: 'orders',
            pageBuilder: (context, state) => AppTransitions.fadeScreen(
              child: const OrdersScreen(),
              state: state,
            ),
          ),

          // Profile
          GoRoute(
            path: RouteNames.profile,
            name: 'profile',
            pageBuilder: (context, state) => AppTransitions.fadeScreen(
              child: const ProfileScreen(),
              state: state,
            ),
          ),
        ],
      ),

      // Product List (by category)
      GoRoute(
        path: RouteNames.productList,
        name: 'productList',
        pageBuilder: (context, state) {
          final categoryId = state.pathParameters['categoryId'];
          return AppTransitions.slideFromRight(
            child: ProductListScreen(categoryId: categoryId),
            state: state,
          );
        },
      ),

      // Product Detail
      GoRoute(
        path: RouteNames.productDetail,
        name: 'productDetail',
        pageBuilder: (context, state) {
          final productId = state.pathParameters['productId'];
          return AppTransitions.sharedAxis(
            child: ProductDetailScreen(productId: productId!),
            state: state,
          );
        },
      ),

      // Cart
      GoRoute(
        path: RouteNames.cart,
        name: 'cart',
        pageBuilder: (context, state) => AppTransitions.slideFromBottom(
          child: const CartScreen(),
          state: state,
        ),
      ),

      // Checkout Flow
      GoRoute(
        path: RouteNames.checkout,
        name: 'checkout',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          child: const CheckoutScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.payment,
        name: 'payment',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          child: const PaymentScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.orderConfirmation,
        name: 'orderConfirmation',
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['orderId'];
          return AppTransitions.fadeScreen(
            child: OrderConfirmationScreen(orderId: orderId!),
            state: state,
          );
        },
      ),

      // Order Detail
      GoRoute(
        path: RouteNames.orderDetail,
        name: 'orderDetail',
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['orderId'];
          return AppTransitions.slideFromRight(
            child: OrderDetailScreen(orderId: orderId!),
            state: state,
          );
        },
      ),

      // Settings
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          child: const SettingsScreen(),
          state: state,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}
