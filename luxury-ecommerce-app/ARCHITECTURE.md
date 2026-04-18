# LUXE - Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Project Structure](#project-structure)
4. [State Management](#state-management)
5. [Navigation](#navigation)
6. [Data Layer](#data-layer)
7. [UI Layer](#ui-layer)
8. [Dependency Injection](#dependency-injection)
9. [Testing Strategy](#testing-strategy)

## Overview

LUXE follows **Clean Architecture** principles with a clear separation of concerns between layers. The app is built with:

- **Flutter** for cross-platform UI
- **Riverpod** for state management
- **Go Router** for navigation
- **Firebase** for backend services
- **Hive** for local storage

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         UI Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Screens   │  │   Widgets   │  │  Animation Layer    │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                      │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                   State Notifiers                        ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐ ││
│  │  │   Cart   │ │ Products │ │ Checkout │ │    Auth      │ ││
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────┘ ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                       Domain Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Models    │  │   Use Cases │  │    Repositories     │ │
│  └─────────────┘  └─────────────┘  │   (Interfaces)      │ │
│                                     └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Firebase  │  │  Local DB   │  │    API Clients      │ │
│  │  - Auth     │  │  - Hive     │  │    - Stripe         │ │
│  │  - Firestore│  │  - Shared   │  │    - REST           │ │
│  │  - Storage  │  │    Prefs    │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants
│   ├── router/             # Navigation and routing
│   ├── theme/              # Design system
│   ├── utils/              # Utilities and extensions
│   └── widgets/            # Reusable widgets
│
├── features/
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer
│   │   ├── domain/         # Domain layer
│   │   └── presentation/   # UI layer
│   │       ├── screens/
│   │       └── providers/
│   │
│   ├── cart/               # Shopping cart feature
│   ├── checkout/           # Checkout flow
│   ├── home/               # Home screen
│   ├── navigation/         # Bottom navigation
│   ├── orders/             # Order management
│   ├── products/           # Product catalog
│   ├── profile/            # User profile
│   ├── splash/             # Splash screen
│   └── wishlist/           # Wishlist feature
│
└── main.dart
```

## State Management

### Riverpod Architecture

We use **Riverpod** for state management because it provides:
- Compile-time safety
- Testability
- Scoped state management
- Built-in caching

### Provider Types

```dart
// State Provider - Simple state
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// State Notifier Provider - Complex state
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Future Provider - Async operations
final productDetailProvider = FutureProvider.family<Product?, String>(
  (ref, productId) async {
    return await ref.read(productRepositoryProvider).getById(productId);
  },
);

// Stream Provider - Real-time data
final ordersStreamProvider = StreamProvider<List<Order>>((ref) {
  return ref.read(orderRepositoryProvider).watchAll();
});
```

### State Flow

```
User Action → Notifier Method → State Update → UI Rebuild
     ↑                                          ↓
     └────────── New Action ←───────────────────┘
```

## Navigation

### Go Router Configuration

```dart
// Deep linking support
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id'];
        return ProductDetailScreen(productId: productId);
      },
    ),
  ],
);
```

### Navigation Patterns

```dart
// Navigate to screen
context.go('/product/123');

// Push screen (add to stack)
context.push('/cart');

// Replace screen
context.replace('/checkout');

// Go back
context.pop();

// Named routes
context.goNamed('product', pathParameters: {'id': '123'});
```

## Data Layer

### Repository Pattern

```dart
// Repository Interface (Domain Layer)
abstract class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product?> getById(String id);
  Future<List<Product>> getByCategory(String categoryId);
}

// Repository Implementation (Data Layer)
class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore;
  
  ProductRepositoryImpl(this._firestore);
  
  @override
  Future<List<Product>> getAll() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
  }
  
  // ...
}
```

### Data Flow

```
UI → Provider → Repository → Data Source
 ↑                              ↓
 └──────── Response ←───────────┘
```

## UI Layer

### Component Hierarchy

```
App
├── Theme
│   └── MaterialApp
│       └── Router
│           └── Navigation Shell
│               ├── Home Screen
│               │   └── Hero Section
│               │   └── Categories Grid
│               │   └── Featured Products
│               ├── Product Screen
│               │   └── Product Detail
│               │   └── Image Gallery
│               └── Cart Screen
│                   └── Cart Items List
│                   └── Summary Card
```

### Widget Types

1. **Screens** - Full pages
2. **Widgets** - Reusable components
3. **Providers** - State management

### Responsive Design

```dart
// Breakpoint-based layouts
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width > 1200 && desktop != null) return desktop!;
    if (width > 768 && tablet != null) return tablet!;
    return mobile;
  }
}
```

## Dependency Injection

### Provider Setup

```dart
// Core dependencies
final firebaseProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Repository providers
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final firestore = ref.watch(firebaseProvider);
  return ProductRepositoryImpl(firestore);
});

// Service providers
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentServiceImpl();
});
```

## Testing Strategy

### Unit Tests

```dart
// Test notifiers
void main() {
  group('CartNotifier', () {
    test('should add item to cart', () {
      final notifier = CartNotifier();
      final product = Product.getSampleProducts().first;
      
      notifier.addItem(product);
      
      expect(notifier.state.length, 1);
      expect(notifier.state.first.product.id, product.id);
    });
  });
}
```

### Widget Tests

```dart
testWidgets('should display product details', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: ProductDetailScreen(productId: 'test'),
      ),
    ),
  );
  
  expect(find.text('Add to Cart'), findsOneWidget);
});
```

### Integration Tests

```dart
testWidgets('complete purchase flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  
  // Navigate to product
  await tester.tap(find.text('Featured'));
  await tester.pumpAndSettle();
  
  // Add to cart
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  
  // Verify cart updated
  expect(find.text('1'), findsOneWidget);
});
```

## Performance Considerations

### State Optimization

```dart
// Use select for granular updates
final cartCount = ref.watch(
  cartProvider.select((cart) => cart.length),
);

// Memoize expensive computations
final sortedProducts = useMemoized(
  () => products..sort((a, b) => a.price.compareTo(b.price)),
  [products],
);
```

### Image Optimization

```dart
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => ShimmerLoading(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheWidth: 800,
);
```

### List Optimization

```dart
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(product: products[index]);
  },
  // Use for large lists
  addAutomaticKeepAlives: false,
  addRepaintBoundaries: false,
)
```

## Security

### Data Validation

```dart
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    if (!value.contains('@')) return 'Invalid email';
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Password must be 8+ characters';
    }
    return null;
  }
}
```

### Secure Storage

```dart
// Store tokens securely
final secureStorage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await secureStorage.write(key: 'auth_token', value: token);
}
```

## Error Handling

### Async Error Handling

```dart
final productsAsync = ref.watch(productsProvider);

return productsAsync.when(
  data: (products) => ProductList(products: products),
  loading: () => LoadingIndicator(),
  error: (error, stack) => ErrorView(message: error.toString()),
);
```

### Global Error Handler

```dart
void main() {
  FlutterError.onError = (details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };
  
  runZonedGuarded(
    () => runApp(MyApp()),
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );
}
```

## Scalability

### Feature-Based Organization

Each feature is self-contained:
- Data layer
- Domain layer
- UI layer
- Tests

### Benefits
- Easy to add new features
- Clear ownership
- Testable in isolation
- Code reusability

### Adding New Features

1. Create feature directory
2. Define models
3. Create repository
4. Implement providers
5. Build UI
6. Add tests
7. Update router

---

## Conclusion

This architecture provides:
- **Maintainability** - Clear separation of concerns
- **Testability** - Dependency injection and mocking
- **Scalability** - Feature-based organization
- **Performance** - Optimized state management
- **Type Safety** - Compile-time checking
