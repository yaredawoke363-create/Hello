import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luxury_ecommerce/core/theme/app_animations.dart';
import 'package:luxury_ecommerce/core/theme/app_colors.dart';
import 'package:luxury_ecommerce/core/theme/app_typography.dart';
import 'package:luxury_ecommerce/core/theme/app_shadows.dart';
import 'package:luxury_ecommerce/core/theme/app_radius.dart';

export 'package:luxury_ecommerce/core/theme/app_colors.dart';
export 'package:luxury_ecommerce/core/theme/app_typography.dart';
export 'package:luxury_ecommerce/core/theme/app_shadows.dart';
export 'package:luxury_ecommerce/core/theme/app_radius.dart';
export 'package:luxury_ecommerce/core/theme/app_spacing.dart';
export 'package:luxury_ecommerce/core/theme/app_animations.dart';

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void setThemeMode(ThemeMode mode) => state = mode;
  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

class AppTheme {
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColors.primary600,
        onPrimary: AppColors.pureWhite,
        primaryContainer: AppColors.primary100,
        onPrimaryContainer: AppColors.primary900,
        secondary: AppColors.accentGold,
        onSecondary: AppColors.pureWhite,
        secondaryContainer: AppColors.gray100,
        onSecondaryContainer: AppColors.gray900,
        surface: AppColors.pureWhite,
        onSurface: AppColors.gray950,
        surfaceVariant: AppColors.gray50,
        onSurfaceVariant: AppColors.gray600,
        background: AppColors.gray50,
        onBackground: AppColors.gray950,
        error: AppColors.error,
        onError: AppColors.pureWhite,
        outline: AppColors.gray200,
        shadow: AppColors.gray900,
      ),
      scaffoldBackgroundColor: AppColors.gray50,
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: _buildAppBarTheme(Brightness.light),
      cardTheme: _buildCardTheme(Brightness.light),
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.light),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.light),
      textButtonTheme: _buildTextButtonTheme(Brightness.light),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
      bottomSheetTheme: _buildBottomSheetTheme(Brightness.light),
      dialogTheme: _buildDialogTheme(Brightness.light),
      snackBarTheme: _buildSnackBarTheme(Brightness.light),
      chipTheme: _buildChipTheme(Brightness.light),
      dividerTheme: _buildDividerTheme(Brightness.light),
      iconTheme: const IconThemeData(
        color: AppColors.gray700,
        size: 24,
      ),
      extensions: [
        CustomThemeExtension(
          glassBackground: AppColors.glassWhite,
          glassBorder: AppColors.glassBorderLight,
          success: AppColors.success,
          warning: AppColors.warning,
          shadowSubtle: AppShadows.subtle,
          shadowMedium: AppShadows.medium,
          shadowStrong: AppShadows.strong,
        ),
      ],
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primary400,
        onPrimary: AppColors.pureWhite,
        primaryContainer: AppColors.primary900,
        onPrimaryContainer: AppColors.primary100,
        secondary: AppColors.accentGold,
        onSecondary: AppColors.pureBlack,
        secondaryContainer: AppColors.gray800,
        onSecondaryContainer: AppColors.gray100,
        surface: AppColors.gray900,
        onSurface: AppColors.gray50,
        surfaceVariant: AppColors.gray800,
        onSurfaceVariant: AppColors.gray400,
        background: AppColors.gray950,
        onBackground: AppColors.gray50,
        error: AppColors.errorDark,
        onError: AppColors.pureWhite,
        outline: AppColors.gray700,
        shadow: AppColors.pureBlack,
      ),
      scaffoldBackgroundColor: AppColors.gray950,
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      cardTheme: _buildCardTheme(Brightness.dark),
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.dark),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.dark),
      textButtonTheme: _buildTextButtonTheme(Brightness.dark),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
      bottomSheetTheme: _buildBottomSheetTheme(Brightness.dark),
      dialogTheme: _buildDialogTheme(Brightness.dark),
      snackBarTheme: _buildSnackBarTheme(Brightness.dark),
      chipTheme: _buildChipTheme(Brightness.dark),
      dividerTheme: _buildDividerTheme(Brightness.dark),
      iconTheme: const IconThemeData(
        color: AppColors.gray300,
        size: 24,
      ),
      extensions: [
        CustomThemeExtension(
          glassBackground: AppColors.glassDark,
          glassBorder: AppColors.glassBorderDark,
          success: AppColors.successDark,
          warning: AppColors.warningDark,
          shadowSubtle: AppShadows.subtleDark,
          shadowMedium: AppShadows.mediumDark,
          shadowStrong: AppShadows.strongDark,
        ),
      ],
    );
  }

  // Text Theme
  static TextTheme _buildTextTheme(Brightness brightness) {
    final base = AppTypography.theme;
    final isDark = brightness == Brightness.dark;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
      ),
      displayMedium: base.displayMedium?.copyWith(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
      ),
      displaySmall: base.displaySmall?.copyWith(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: isDark ? AppColors.gray200 : AppColors.gray800,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: isDark ? AppColors.gray300 : AppColors.gray600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: isDark ? AppColors.gray200 : AppColors.gray700,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: isDark ? AppColors.gray300 : AppColors.gray600,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: isDark ? AppColors.gray400 : AppColors.gray500,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: isDark ? AppColors.gray200 : AppColors.gray700,
      ),
      labelMedium: base.labelMedium?.copyWith(
        color: isDark ? AppColors.gray300 : AppColors.gray600,
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: isDark ? AppColors.gray400 : AppColors.gray500,
      ),
    );
  }

  // App Bar Theme
  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: isDark ? AppColors.gray950 : AppColors.gray50,
      foregroundColor: isDark ? AppColors.gray50 : AppColors.gray950,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
        size: 24,
      ),
    );
  }

  // Card Theme
  static CardTheme _buildCardTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return CardTheme(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: isDark ? AppColors.gray900 : AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    );
  }

  // Elevated Button Theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isDark ? AppColors.primary400 : AppColors.primary600,
        foregroundColor: AppColors.pureWhite,
        minimumSize: const Size(64, 56),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        textStyle: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(
          AppColors.pureWhite.withOpacity(0.1),
        ),
      ),
    );
  }

  // Outlined Button Theme
  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: isDark ? AppColors.gray50 : AppColors.gray950,
        minimumSize: const Size(64, 56),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(
          color: isDark ? AppColors.gray700 : AppColors.gray200,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        textStyle: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Text Button Theme
  static TextButtonThemeData _buildTextButtonTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: isDark ? AppColors.primary400 : AppColors.primary600,
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        textStyle: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Input Decoration Theme
  static InputDecorationTheme _buildInputDecorationTheme(
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.gray800 : AppColors.gray100,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: BorderSide(
          color: isDark ? AppColors.primary400 : AppColors.primary600,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      hintStyle: AppTypography.bodyLarge.copyWith(
        color: isDark ? AppColors.gray500 : AppColors.gray400,
      ),
      labelStyle: AppTypography.bodyLarge.copyWith(
        color: isDark ? AppColors.gray400 : AppColors.gray500,
      ),
      errorStyle: AppTypography.labelSmall.copyWith(
        color: AppColors.error,
        height: 0.8,
      ),
      prefixIconColor: isDark ? AppColors.gray400 : AppColors.gray500,
      suffixIconColor: isDark ? AppColors.gray400 : AppColors.gray500,
    );
  }

  // Bottom Sheet Theme
  static BottomSheetThemeData _buildBottomSheetTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return BottomSheetThemeData(
      backgroundColor: isDark ? AppColors.gray900 : AppColors.pureWhite,
      modalBackgroundColor: isDark ? AppColors.gray900 : AppColors.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
    );
  }

  // Dialog Theme
  static DialogTheme _buildDialogTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return DialogTheme(
      backgroundColor: isDark ? AppColors.gray900 : AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      elevation: 0,
      titleTextStyle: AppTypography.headlineSmall.copyWith(
        color: isDark ? AppColors.gray50 : AppColors.gray950,
      ),
      contentTextStyle: AppTypography.bodyLarge.copyWith(
        color: isDark ? AppColors.gray300 : AppColors.gray600,
      ),
    );
  }

  // Snack Bar Theme
  static SnackBarThemeData _buildSnackBarTheme(Brightness brightness) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      contentTextStyle: AppTypography.bodyMedium,
      elevation: 0,
    );
  }

  // Chip Theme
  static ChipThemeData _buildChipTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ChipThemeData(
      backgroundColor: isDark ? AppColors.gray800 : AppColors.gray100,
      disabledColor: isDark ? AppColors.gray800 : AppColors.gray100,
      selectedColor: isDark ? AppColors.primary900 : AppColors.primary100,
      secondarySelectedColor:
          isDark ? AppColors.primary900 : AppColors.primary100,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: isDark ? AppColors.gray200 : AppColors.gray700,
      ),
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(
        color: isDark ? AppColors.primary400 : AppColors.primary600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
    );
  }

  // Divider Theme
  static DividerThemeData _buildDividerTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return DividerThemeData(
      color: isDark ? AppColors.gray800 : AppColors.gray200,
      thickness: 1,
      space: 1,
    );
  }
}

// Custom Theme Extension for Glassmorphism
@immutable
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  const CustomThemeExtension({
    required this.glassBackground,
    required this.glassBorder,
    required this.success,
    required this.warning,
    required this.shadowSubtle,
    required this.shadowMedium,
    required this.shadowStrong,
  });

  final Color glassBackground;
  final Color glassBorder;
  final Color success;
  final Color warning;
  final List<BoxShadow> shadowSubtle;
  final List<BoxShadow> shadowMedium;
  final List<BoxShadow> shadowStrong;

  @override
  CustomThemeExtension copyWith({
    Color? glassBackground,
    Color? glassBorder,
    Color? success,
    Color? warning,
    List<BoxShadow>? shadowSubtle,
    List<BoxShadow>? shadowMedium,
    List<BoxShadow>? shadowStrong,
  }) {
    return CustomThemeExtension(
      glassBackground: glassBackground ?? this.glassBackground,
      glassBorder: glassBorder ?? this.glassBorder,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      shadowSubtle: shadowSubtle ?? this.shadowSubtle,
      shadowMedium: shadowMedium ?? this.shadowMedium,
      shadowStrong: shadowStrong ?? this.shadowStrong,
    );
  }

  @override
  CustomThemeExtension lerp(
    ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      shadowSubtle: shadowSubtle,
      shadowMedium: shadowMedium,
      shadowStrong: shadowStrong,
    );
  }
}

// Extension for easy access
extension CustomThemeExtensionX on BuildContext {
  CustomThemeExtension get customTheme {
    return Theme.of(this).extension<CustomThemeExtension>()!;
  }
}
