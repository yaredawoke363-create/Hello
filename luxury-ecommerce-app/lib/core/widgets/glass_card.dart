import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:luxury_ecommerce/core/theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.blur = 20,
    this.borderRadius,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.shadows,
    this.alignment,
    this.width,
    this.height,
    this.constraints,
  });

  final Widget child;
  final double blur;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final customTheme = context.customTheme;

    return Container(
      width: width,
      height: height,
      margin: margin,
      constraints: constraints,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.card),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            alignment: alignment,
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? customTheme.glassBackground,
              borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: borderColor ?? customTheme.glassBorder,
                width: 1,
              ),
              boxShadow: shadows ?? customTheme.shadowMedium,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassBottomSheet extends StatelessWidget {
  const GlassBottomSheet({
    super.key,
    required this.child,
    this.blur = 30,
    this.borderRadius = const BorderRadius.vertical(
      top: Radius.circular(AppRadius.sheet),
    ),
    this.padding,
    this.maxHeight,
    this.minHeight,
  });

  final Widget child;
  final double blur;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? maxHeight;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final customTheme = context.customTheme;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.85,
            minHeight: minHeight ?? 0,
          ),
          decoration: BoxDecoration(
            color: customTheme.glassBackground,
            borderRadius: borderRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.blur = 20,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.titleSpacing,
    this.toolbarHeight = kToolbarHeight,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double blur;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final double? titleSpacing;
  final double toolbarHeight;

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final customTheme = context.customTheme;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AppBar(
          title: title,
          leading: leading,
          actions: actions,
          bottom: bottom,
          elevation: elevation,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          toolbarHeight: toolbarHeight,
          backgroundColor:
              backgroundColor ?? customTheme.glassBackground.withOpacity(0.8),
          foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
          systemOverlayStyle: theme.appBarTheme.systemOverlayStyle,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: customTheme.glassBorder,
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
