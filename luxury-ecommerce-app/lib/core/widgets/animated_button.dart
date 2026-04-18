import 'package:flutter/material.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height = 56,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.loading = false,
    this.disabled = false,
    this.enableHaptic = true,
    this.scaleFactor = 0.96,
    this.springAnimation = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final bool loading;
  final bool disabled;
  final bool enableHaptic;
  final double scaleFactor;
  final bool springAnimation;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.springAnimation ? Curves.elasticOut : Curves.easeOut,
      ),
    );

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.disabled || widget.loading) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.disabled || widget.loading) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (widget.disabled || widget.loading) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = widget.backgroundColor ??
        (isDark ? AppColors.primary400 : AppColors.primary600);
    final fgColor = widget.foregroundColor ?? Colors.white;
    final radius = widget.borderRadius ?? BorderRadius.circular(AppRadius.button);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.disabled || widget.loading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.disabled || widget.loading
                    ? bgColor.withOpacity(0.5)
                    : bgColor,
                borderRadius: radius,
                boxShadow: [
                  if (_isPressed)
                    BoxShadow(
                      color: bgColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  else
                    BoxShadow(
                      color: bgColor.withOpacity(0.2),
                      blurRadius: _elevationAnimation.value * 2,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: null,
                    splashColor: fgColor.withOpacity(0.1),
                    highlightColor: fgColor.withOpacity(0.05),
                    child: Container(
                      padding: widget.padding,
                      alignment: Alignment.center,
                      child: widget.loading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(fgColor),
                              ),
                            )
                          : DefaultTextStyle(
                              style: AppTypography.labelLarge.copyWith(
                                color: fgColor,
                                fontWeight: FontWeight.w600,
                              ),
                              child: widget.child,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedIconButton extends StatefulWidget {
  const AnimatedIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 48,
    this.iconSize = 24,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.elevation = 0,
    this.scaleFactor = 0.85,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final double scaleFactor;

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = widget.backgroundColor ??
        (isDark ? AppColors.gray800 : AppColors.gray100);
    final fgColor = widget.iconColor ??
        (isDark ? AppColors.gray200 : AppColors.gray700);
    final radius =
        widget.borderRadius ?? BorderRadius.circular(widget.size / 2);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: radius,
                boxShadow: widget.elevation > 0
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: widget.elevation * 4,
                          offset: Offset(0, widget.elevation),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: null,
                    splashColor: fgColor.withOpacity(0.1),
                    highlightColor: fgColor.withOpacity(0.05),
                    child: Center(
                      child: Icon(
                        widget.icon,
                        size: widget.iconSize,
                        color: fgColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
