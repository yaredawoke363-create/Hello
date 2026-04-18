import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';
import 'package:luxury_ecommerce/core/theme/app_animations.dart';

class AppTransitions {
  AppTransitions._();

  // Fade transition
  static CustomTransitionPage fadeScreen({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: AppAnimations.pageTransition,
      reverseTransitionDuration: AppAnimations.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: AppAnimations.pageTransitionCurve,
          ),
          child: child,
        );
      },
    );
  }

  // Slide from right (iOS style)
  static CustomTransitionPage slideFromRight({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: AppAnimations.pageTransition,
      reverseTransitionDuration: AppAnimations.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = AppAnimations.smooth;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // Slide from bottom (modals)
  static CustomTransitionPage slideFromBottom({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: AppAnimations.pageTransition,
      reverseTransitionDuration: AppAnimations.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = AppAnimations.smooth;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  // Shared axis transition
  static CustomTransitionPage sharedAxis({
    required Widget child,
    required GoRouterState state,
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: AppAnimations.pageTransition,
      reverseTransitionDuration: AppAnimations.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
          child: child,
        );
      },
    );
  }

  // Fade through transition
  static CustomTransitionPage fadeThrough({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: AppAnimations.pageTransition,
      reverseTransitionDuration: AppAnimations.pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Scale transition (for dialogs/modals)
  static CustomTransitionPage scale({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: AppAnimations.normal,
      reverseTransitionDuration: AppAnimations.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: AppAnimations.emphasize,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // Hero transition wrapper
  static CustomTransitionPage hero({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

// Route observer for analytics
class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Log screen view
    _logScreenView(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _logScreenView(previousRoute.settings.name);
    }
  }

  void _logScreenView(String? screenName) {
    if (screenName != null) {
      // TODO: Implement analytics logging
      debugPrint('Screen viewed: $screenName');
    }
  }
}
