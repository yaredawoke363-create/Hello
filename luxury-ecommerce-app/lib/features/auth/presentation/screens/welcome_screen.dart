import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/widgets/animated_button.dart';
import 'package:luxury_ecommerce/core/widgets/glass_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
            fit: BoxFit.cover,
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),

                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.accentGold,
                          AppColors.accentChampagne,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGold.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.diamond,
                      size: 40,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scale(delay: 200.ms)
                      .then()
                      .shimmer(duration: 2.seconds),

                  const SizedBox(height: 32),

                  // Brand Name
                  Text(
                    'LUXE',
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 8,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 600.ms),

                  const SizedBox(height: 16),

                  // Tagline
                  Text(
                    'Discover the Art of Luxury',
                    style: AppTypography.headlineSmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0, delay: 600.ms, duration: 600.ms),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Experience premium shopping with curated collections of luxury watches, bags, shoes, and accessories from the world\'s finest brands.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 600.ms),

                  const Spacer(),

                  // Feature Highlights
                  Row(
                    children: [
                      _FeatureItem(
                        icon: PhosphorIcons.shieldCheck,
                        label: 'Authentic',
                      ),
                      _FeatureItem(
                        icon: PhosphorIcons.truck,
                        label: 'Free Shipping',
                      ),
                      _FeatureItem(
                        icon: PhosphorIcons.arrowsClockwise,
                        label: 'Easy Returns',
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 1000.ms, duration: 600.ms),

                  const SizedBox(height: 48),

                  // Buttons
                  AnimatedButton(
                    onPressed: () {
                      context.go(RouteNames.register);
                    },
                    width: double.infinity,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    child: const Text('Create Account'),
                  )
                      .animate()
                      .fadeIn(delay: 1200.ms, duration: 400.ms)
                      .slideY(begin: 0.3, end: 0, delay: 1200.ms, duration: 400.ms),

                  const SizedBox(height: 16),

                  // Sign In Link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.go(RouteNames.login);
                      },
                      child: Text(
                        'Already have an account? Sign In',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1400.ms, duration: 400.ms),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.accentGold,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
