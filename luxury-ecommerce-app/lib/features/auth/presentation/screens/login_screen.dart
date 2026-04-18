import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:luxury_ecommerce/core/router/route_names.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';
import 'package:luxury_ecommerce/core/utils/extensions.dart';
import 'package:luxury_ecommerce/core/widgets/animated_button.dart';
import 'package:luxury_ecommerce/core/widgets/glass_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    // Simulate login
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.gray900,
                        AppColors.gray950,
                      ]
                    : [
                        AppColors.primary50,
                        AppColors.gray50,
                      ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(PhosphorIcons.arrowLeft),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Header
                  Text(
                    'Welcome Back',
                    style: AppTypography.displayMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0, duration: 600.ms),

                  const SizedBox(height: 8),

                  Text(
                    'Sign in to continue shopping luxury',
                    style: AppTypography.bodyLarge.copyWith(
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms),

                  const SizedBox(height: 48),

                  // Form
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Email
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(PhosphorIcons.envelope),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(PhosphorIcons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? PhosphorIcons.eye
                                    : PhosphorIcons.eyeSlash,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.push(RouteNames.forgotPassword);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: AppTypography.labelLarge.copyWith(
                                color: isDark
                                    ? AppColors.primary400
                                    : AppColors.primary600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Button
                        AnimatedButton(
                          onPressed: _isLoading ? null : _login,
                          width: double.infinity,
                          loading: _isLoading,
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 600.ms),

                  const SizedBox(height: 32),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.gray300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or continue with',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.gray400 : AppColors.gray500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.gray300)),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Social Login
                  Row(
                    children: [
                      Expanded(
                        child: _SocialLoginButton(
                          icon: 'G',
                          label: 'Google',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SocialLoginButton(
                          icon: '',
                          label: 'Apple',
                          onTap: () {},
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms),

                  const SizedBox(height: 48),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.gray400 : AppColors.gray500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(RouteNames.register);
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTypography.labelLarge.copyWith(
                            color: isDark
                                ? AppColors.primary400
                                : AppColors.primary600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray800 : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(
            color: isDark ? AppColors.gray700 : AppColors.gray200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
