import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/utils/extensions.dart';
import 'package:luxury_ecommerce/core/widgets/animated_button.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PageController _pageController;
  double _currentPage = 0;

  final List<_HeroItem> _heroItems = [
    _HeroItem(
      title: 'Luxury',
      subtitle: 'Collection',
      description: 'Discover our premium selection of handcrafted pieces',
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772',
      cta: 'Shop Now',
    ),
    _HeroItem(
      title: 'Elegance',
      subtitle: 'Redefined',
      description: 'Experience the perfect blend of style and sophistication',
      imageUrl: 'https://images.unsplash.com/photo-1552346154-21d32810aba3',
      cta: 'Explore',
    ),
    _HeroItem(
      title: 'Timeless',
      subtitle: 'Design',
      description: 'Classic pieces that transcend trends and seasons',
      imageUrl: 'https://images.unsplash.com/photo-1491553895911-0055uj3adda',
      cta: 'View Collection',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pageController = PageController(viewportFraction: 1)
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page ?? 0;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;
    final screenWidth = context.screenWidth;

    return SizedBox(
      height: screenHeight * 0.85,
      child: Stack(
        children: [
          // 3D Parallax Background
          PageView.builder(
            controller: _pageController,
            itemCount: _heroItems.length,
            itemBuilder: (context, index) {
              final item = _heroItems[index];
              final pageOffset = _currentPage - index;
              final parallax = pageOffset * 50;

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image with Parallax
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(parallax, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(item.imageUrl),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: Transform.scale(
                            scale: 1.1 + (math.sin(_controller.value * 2 * math.pi) * 0.02),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Container(),
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0, 0.5, 1],
                      ),
                    ),
                  ),

                  // Content
                  Positioned(
                    bottom: screenHeight * 0.15,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Animated Title
                        Text(
                          item.title,
                          style: AppTypography.displayLarge.copyWith(
                            color: Colors.white,
                            height: 1.1,
                          ),
                        )
                            .animate(
                              delay: Duration(milliseconds: index * 200 + 300),
                            )
                            .fadeIn(duration: 800.ms)
                            .slideY(begin: 0.5, end: 0, duration: 800.ms)
                            .then()
                            .shimmer(
                              duration: 1200.ms,
                              color: Colors.white.withOpacity(0.5),
                            ),

                        const SizedBox(height: 8),

                        // Subtitle with gold accent
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              AppColors.accentGold,
                              AppColors.accentChampagne,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            item.subtitle,
                            style: AppTypography.displayMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                            .animate(
                              delay: Duration(milliseconds: index * 200 + 500),
                            )
                            .fadeIn(duration: 800.ms)
                            .slideX(begin: -0.2, end: 0, duration: 800.ms),

                        const SizedBox(height: 16),

                        // Description
                        Text(
                          item.description,
                          style: AppTypography.bodyLarge.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        )
                            .animate(
                              delay: Duration(milliseconds: index * 200 + 700),
                            )
                            .fadeIn(duration: 600.ms),

                        const SizedBox(height: 32),

                        // CTA Button
                        AnimatedButton(
                          onPressed: () {
                            context.push(RouteNames.productList.replaceAll(':categoryId', 'all'));
                          },
                          width: 200,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.cta),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        )
                            .animate(
                              delay: Duration(milliseconds: index * 200 + 900),
                            )
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0, duration: 600.ms),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Page Indicators
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _heroItems.length,
                (index) {
                  final isActive = _currentPage.round() == index;
                  return GestureDetector(
                    onTap: () => _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Floating Stats (Glassmorphism)
          Positioned(
            top: screenHeight * 0.2,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '2024',
                    style: AppTypography.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
                .animate(delay: 1200.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: 0.5, end: 0, duration: 600.ms),
          ),
        ],
      ),
    );
  }
}

class _HeroItem {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String cta;

  _HeroItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.cta,
  });
}
