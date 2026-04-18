# LUXE - Premium eCommerce Mobile Application

A world-class, luxury eCommerce Android application built with Flutter, featuring Apple-level UI/UX design, smooth 60fps animations, glassmorphism effects, and secure payment integration.

## Overview

LUXE is an ultra-premium eCommerce mobile application designed to deliver a luxury shopping experience rivaling Apple, Tesla, and Nike in visual sophistication and interaction quality. Every pixel, animation, and interaction has been carefully crafted to provide a premium user experience.

## Features

### Core Features
- Home with 3D Parallax Hero Section
- Product Catalog with Category Navigation
- Product Detail with Image Gallery
- Shopping Cart with Real-time Updates
- Secure Checkout Flow
- Order Tracking & History
- User Authentication (Login/Register)
- Wishlist Management
- Dark/Light Theme Support

### Premium UI/UX Features
- 60fps Smooth Animations
- Glassmorphism Design Language
- 3D Parallax Scroll Effects
- Spring Physics Motion
- Animated Typography
- Skeleton Loading States
- Micro-interactions on every button
- Hero Transitions
- Shared Element Animations
- Bottom Sheet Modals

## Design System

### Color Palette
- **Primary**: Deep Navy Blue (#2563EB)
- **Accent**: Luxury Gold (#D4AF37), Champagne (#F7E7CE)
- **Neutral**: Warm Gray Scale (Stone palette)
- **Semantic**: Success (#10B981), Warning (#F59E0B), Error (#EF4444)

### Typography
- **Primary Font**: Inter (Weights: 100-900)
- **Display Font**: Playfair Display (Luxury headings)
- **Type Scale**: 12-step system with tabular figures for prices

### Spacing System
- Base unit: 4px
- Scale: 4, 8, 12, 16, 24, 32, 48, 64, 96

### Shadows & Elevation
- Subtle (Cards at rest)
- Medium (Cards elevated)
- Strong (Modals, Sheets)
- Glow (Premium accents)

## Architecture

### Tech Stack
- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Navigation**: Go Router
- **Animations**: flutter_animate, animations package
- **Backend**: Firebase
  - Firebase Auth (Authentication)
  - Cloud Firestore (Database)
  - Firebase Storage (Images)
  - Firebase Analytics
- **Payment**: Stripe
- **Local Storage**: Hive, Shared Preferences

### Project Structure
```
lib/
├── core/
│   ├── theme/           # Design system, colors, typography
│   ├── router/          # Navigation, routes, transitions
│   ├── utils/           # Extensions, helpers, logger
│   ├── widgets/         # Reusable UI components
│   └── constants/       # App constants
├── features/
│   ├── home/            # Home screen, hero section
│   ├── products/        # Product catalog, detail
│   ├── cart/            # Shopping cart
│   ├── checkout/        # Checkout flow, payment
│   ├── orders/          # Order history, tracking
│   ├── auth/            # Authentication screens
│   ├── profile/         # User profile, settings
│   ├── wishlist/        # Wishlist functionality
│   ├── navigation/      # Bottom navigation
│   └── splash/          # Splash screen
└── main.dart
```

### Clean Architecture
- **Domain Layer**: Entities, repositories interfaces
- **Data Layer**: Repository implementations, data sources
- **Presentation Layer**: UI, providers, state management

## Key Components

### Glassmorphism Components
- `GlassCard` - Glass effect container
- `GlassBottomSheet` - Modal with blur
- `GlassAppBar` - Transparent app bar with blur

### Animation Components
- `AnimatedButton` - Button with scale and shadow animations
- `AnimatedIconButton` - Icon button with press feedback
- `AnimatedPrice` - Animated price counter
- `AnimatedCounter` - Number counter animation

### Custom Transitions
- Fade transitions
- Slide from right (iOS style)
- Slide from bottom (modals)
- Shared axis transitions
- Hero animations

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Firebase CLI (for deployment)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/luxe-ecommerce.git
cd luxe-ecommerce
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
```bash
flutterfire configure
```

4. Add your assets:
```bash
# Create directories
mkdir -p assets/fonts assets/images assets/icons

# Add your font files
# - Inter (Thin to Black)
# - Playfair Display (Regular to Black)
```

5. Run the app:
```bash
flutter run
```

## Configuration

### Firebase Setup
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Authentication (Email/Password, Google)
3. Create Firestore database
4. Enable Firebase Storage
5. Run `flutterfire configure`

### Stripe Payment Setup
1. Create a Stripe account at [stripe.com](https://stripe.com)
2. Get your API keys from the Dashboard
3. Create payment intents in your backend
4. Update the payment configuration in `lib/core/config/`

### Environment Variables
Create a `.env` file:
```
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
```

## Deployment

### Android

1. Build release APK:
```bash
flutter build apk --release
```

2. Build App Bundle:
```bash
flutter build appbundle --release
```

3. Upload to Google Play Console:
- Go to [play.google.com/console](https://play.google.com/console)
- Create a new app
- Upload the AAB file
- Fill in store listing details

### iOS (if needed later)
```bash
flutter build ios --release
```

## Performance Optimization

- Image caching with `cached_network_image`
- List virtualization
- Widget memoization
- Lazy loading
- Debounced search
- 60fps target animations

## Security

- Firebase Authentication for secure login
- Firestore security rules
- Payment tokenization via Stripe
- Input validation
- Secure storage for sensitive data

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/app_test.dart

# Check code quality
flutter analyze
```

## Customization

### Adding New Categories
Edit `lib/features/products/domain/models/product.dart`:
```dart
static List<Category> getSampleCategories() {
  return [
    const Category(id: 'cat_new', name: 'New Category', ...),
    // ...
  ];
}
```

### Changing Colors
Edit `lib/core/theme/app_colors.dart`:
```dart
static const Color primary600 = Color(0xFFYOUR_COLOR);
```

### Adding Animations
Use the flutter_animate package:
```dart
Text('Hello')
  .animate()
  .fadeIn(duration: 600.ms)
  .slideY(begin: 0.2, end: 0, duration: 600.ms)
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

- Design inspired by Apple, Tesla, and Nike
- Icons by Phosphor Icons
- Fonts: Inter (Google Fonts), Playfair Display (Google Fonts)

## Support

For support, email support@luxe.com or join our Slack channel.

---

Built with precision and passion by the LUXE Team
