# Luxury eCommerce Design System

## Brand Foundation

### Vision
An ultra-premium eCommerce experience that rivals Apple, Tesla, and Nike in visual sophistication and interaction quality. Every pixel matters. Every animation serves a purpose.

### Design Principles
1. **Precision** - Every element is intentionally placed
2. **Depth** - Layered interfaces with glassmorphism and parallax
3. **Motion** - Smooth 60fps animations with spring physics
4. **Breathing Room** - Generous whitespace creates luxury feel
5. **Hierarchy** - Clear visual priority guides the eye

---

## Color System

### Primitive Colors

```dart
class AppColors {
  // Pure Scale
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);

  // Neutral Scale (Warm Gray)
  static const Color gray50 = Color(0xFFFAFAF9);
  static const Color gray100 = Color(0xFFF5F5F4);
  static const Color gray200 = Color(0xFFE7E5E4);
  static const Color gray300 = Color(0xFFD6D3D1);
  static const Color gray400 = Color(0xFFA8A29E);
  static const Color gray500 = Color(0xFF78716C);
  static const Color gray600 = Color(0xFF57534E);
  static const Color gray700 = Color(0xFF44403C);
  static const Color gray800 = Color(0xFF292524);
  static const Color gray900 = Color(0xFF1C1917);
  static const Color gray950 = Color(0xFF0C0A09);

  // Primary (Deep Navy with luxury feel)
  static const Color primary50 = Color(0xFFEFF6FF);
  static const Color primary100 = Color(0xFFDBEAFE);
  static const Color primary200 = Color(0xFFBFDBFE);
  static const Color primary300 = Color(0xFF93C5FD);
  static const Color primary400 = Color(0xFF60A5FA);
  static const Color primary500 = Color(0xFF3B82F6);
  static const Color primary600 = Color(0xFF2563EB);
  static const Color primary700 = Color(0xFF1D4ED8);
  static const Color primary800 = Color(0xFF1E40AF);
  static const Color primary900 = Color(0xFF1E3A8A);

  // Accent (Gold/Champagne for luxury)
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentChampagne = Color(0xFFF7E7CE);
  static const Color accentCopper = Color(0xFFB87333);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
```

### Semantic Tokens (Light Mode)

```dart
class LightThemeColors {
  // Background
  static const Color backgroundPrimary = AppColors.pureWhite;
  static const Color backgroundSecondary = AppColors.gray50;
  static const Color backgroundTertiary = AppColors.gray100;

  // Surface (Cards, Sheets, Dialogs)
  static const Color surfacePrimary = AppColors.pureWhite;
  static const Color surfaceSecondary = AppColors.gray50;
  static const Color surfaceElevated = AppColors.pureWhite;

  // Glassmorphism Surfaces
  static const Color glassBackground = Color(0xCCFFFFFF); // 80% opacity white
  static const Color glassBorder = Color(0x1A000000); // 10% black

  // Text
  static const Color textPrimary = AppColors.gray950;
  static const Color textSecondary = AppColors.gray600;
  static const Color textTertiary = AppColors.gray400;
  static const Color textInverse = AppColors.pureWhite;

  // Accent
  static const Color accentPrimary = AppColors.primary600;
  static const Color accentSecondary = AppColors.accentGold;

  // Status
  static const Color statusSuccess = AppColors.success;
  static const Color statusWarning = AppColors.warning;
  static const Color statusError = AppColors.error;
}
```

### Semantic Tokens (Dark Mode)

```dart
class DarkThemeColors {
  // Background
  static const Color backgroundPrimary = AppColors.gray950;
  static const Color backgroundSecondary = AppColors.gray900;
  static const Color backgroundTertiary = AppColors.gray800;

  // Surface
  static const Color surfacePrimary = AppColors.gray900;
  static const Color surfaceSecondary = AppColors.gray800;
  static const Color surfaceElevated = AppColors.gray800;

  // Glassmorphism Surfaces
  static const Color glassBackground = Color(0xB3121212); // 70% opacity dark
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white

  // Text
  static const Color textPrimary = AppColors.gray50;
  static const Color textSecondary = AppColors.gray400;
  static const Color textTertiary = AppColors.gray500;
  static const Color textInverse = AppColors.gray950;

  // Accent
  static const Color accentPrimary = AppColors.primary400;
  static const Color accentSecondary = AppColors.accentGold;

  // Status (slightly brighter for dark mode)
  static const Color statusSuccess = Color(0xFF34D399);
  static const Color statusWarning = Color(0xFFFBBF24);
  static const Color statusError = Color(0xFFF87171);
}
```

---

## Typography System

### Font Family
- **Primary**: SF Pro Display (iOS) / Roboto (Android fallback)
- **Accent**: Playfair Display (for luxury headings)

```dart
class AppTypography {
  // Font Families
  static const String fontPrimary = 'Inter';
  static const String fontDisplay = 'PlayfairDisplay';

  // Display Styles (Large Hero Text)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.6,
  );

  // Label Styles (Buttons, Captions)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.5,
  );

  // Price Styles (Tabular Numbers)
  static const TextStyle priceLarge = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle priceMedium = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle priceSmall = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
```

---

## Spacing System

```dart
class AppSpacing {
  // Base unit: 4px
  static const double unit = 4.0;

  // Scale
  static const double xxs = unit;        // 4
  static const double xs = unit * 2;     // 8
  static const double sm = unit * 3;     // 12
  static const double md = unit * 4;     // 16
  static const double lg = unit * 6;     // 24
  static const double xl = unit * 8;     // 32
  static const double xxl = unit * 12;   // 48
  static const double xxxl = unit * 16;  // 64
  static const double huge = unit * 24;  // 96

  // Section Spacing
  static const double sectionSmall = 64.0;
  static const double sectionMedium = 96.0;
  static const double sectionLarge = 128.0;

  // Screen Padding
  static const double screenPaddingHorizontal = 24.0;
  static const double screenPaddingVertical = 16.0;
}
```

---

## Elevation & Shadows

```dart
class AppShadows {
  // Subtle (Cards at rest)
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Medium (Cards elevated)
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Strong (Modals, Sheets)
  static const List<BoxShadow> strong = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  // Glow (Premium accents)
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x403B82F6), // 25% primary
      blurRadius: 20,
      spreadRadius: -5,
    ),
  ];
}
```

---

## Border Radius

```dart
class AppRadius {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double full = 9999;

  // Component specific
  static const double button = 12;
  static const double card = 16;
  static const double chip = 8;
  static const double input = 12;
  static const double avatar = 9999;
  static const double sheet = 24;
}
```

---

## Animation System

```dart
class AppAnimations {
  // Durations
  static const Duration instant = Duration(milliseconds: 50);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration emphasis = Duration(milliseconds: 450);

  // Curves
  static const Curve standard = Curves.easeInOut;
  static const Curve decelerate = Curves.easeOutCubic;
  static const Curve accelerate = Curves.easeInCubic;
  static const Curve emphasize = Curves.easeOutBack;
  static const Curve spring = Curves.elasticOut;
  static const Curve smooth = Cubic(0.4, 0.0, 0.2, 1);

  // Spring Configurations
  static const SpringDescription springGentle = SpringDescription(
    mass: 1,
    stiffness: 100,
    damping: 15,
  );

  static const SpringDescription springSnappy = SpringDescription(
    mass: 1,
    stiffness: 400,
    damping: 25,
  );

  static const SpringDescription springBouncy = SpringDescription(
    mass: 1,
    stiffness: 300,
    damping: 10,
  );
}
```

---

## Glassmorphism Specification

```dart
class Glassmorphism {
  // Standard Glass Card
  static BoxDecoration standard(BuildContext context) => BoxDecoration(
    color: Theme.of(context).brightness == Brightness.light
        ? LightThemeColors.glassBackground
        : DarkThemeColors.glassBackground,
    borderRadius: BorderRadius.circular(AppRadius.card),
    border: Border.all(
      color: Theme.of(context).brightness == Brightness.light
          ? LightThemeColors.glassBorder
          : DarkThemeColors.glassBorder,
      width: 1,
    ),
    boxShadow: AppShadows.medium,
  );

  // Strong Glass (for modals)
  static BoxDecoration strong(BuildContext context) => BoxDecoration(
    color: Theme.of(context).brightness == Brightness.light
        ? const Color(0xE6FFFFFF) // 90% white
        : const Color(0xE61C1917), // 90% dark
    borderRadius: BorderRadius.circular(AppRadius.sheet),
    border: Border.all(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0x1F000000)
          : const Color(0x1FFFFFFF),
      width: 1,
    ),
    boxShadow: AppShadows.strong,
  );

  // Background Blur
  static Widget blurBackground({
    required Widget child,
    double sigma = 20,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: child,
      ),
    );
  }
}
```

---

## Component Specifications

### Buttons

```dart
class ButtonSpecs {
  // Primary Button
  static const Size primarySize = Size(double.infinity, 56);
  static const EdgeInsets primaryPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.md,
  );

  // Secondary Button
  static const Size secondarySize = Size(double.infinity, 48);

  // Icon Button
  static const Size iconButtonSize = Size(48, 48);
  static const Size iconButtonSmall = Size(40, 40);
}
```

### Cards

```dart
class CardSpecs {
  // Product Card
  static const double productCardWidth = 180;
  static const double productCardHeight = 260;
  static const double productCardImageHeight = 180;

  // Category Card
  static const double categoryCardSize = 120;

  // Standard Card Padding
  static const EdgeInsets padding = EdgeInsets.all(AppSpacing.md);
}
```

---

## Responsive Breakpoints

```dart
class Breakpoints {
  static const double mobile = 375;
  static const double mobileLarge = 414;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1440;
}
```

---

## Icon System

- **Library**: Phosphor Icons (regular, bold, fill variants)
- **Size Scale**: 16 (xs), 20 (sm), 24 (md), 32 (lg), 48 (xl)
- **Stroke Width**: 1.5px (thin), 2px (regular), 2.5px (bold)

```dart
class IconSizes {
  static const double xs = 16;
  static const double sm = 20;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 48;
}
```

---

## Z-Index Scale

```dart
class ZIndex {
  static const int base = 0;
  static const int dropdown = 100;
  static const int sticky = 200;
  static const int fixed = 300;
  static const int modalBackdrop = 400;
  static const int modal = 500;
  static const int toast = 600;
  static const int tooltip = 700;
}
```

---

## Accessibility Standards

- **Minimum Touch Target**: 48x48dp (Material) / 44x44pt (iOS)
- **Color Contrast**: 4.5:1 minimum for normal text, 3:1 for large text
- **Focus Indicators**: 2-4px visible rings
- **Motion**: Respect `prefers-reduced-motion`
- **Screen Reader**: All interactive elements labeled
