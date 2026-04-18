# LUXE - Deployment Guide

This guide covers the complete deployment process for the LUXE premium eCommerce application.

## Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio or Xcode
- Firebase CLI
- Stripe Account
- Google Play Console Access
- Code signing keys

## Environment Setup

### 1. Flutter SDK

```bash
# Check Flutter version
flutter doctor

# Upgrade if needed
flutter upgrade
```

### 2. Firebase CLI

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

### 3. Project Dependencies

```bash
# Get dependencies
flutter pub get

# Run code generation (if needed)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Firebase Configuration

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create Project"
3. Enter project name: `luxe-ecommerce`
4. Enable Google Analytics
5. Create project

### 2. Configure Firebase for Flutter

```bash
# Configure Firebase
flutterfire configure

# Select your project when prompted
# This generates lib/firebase_options.dart
```

### 3. Enable Firebase Services

#### Authentication
1. Go to Authentication > Sign-in method
2. Enable Email/Password
3. Enable Google Sign-in
4. Add authorized domains

#### Firestore Database
1. Go to Firestore Database
2. Create database (start in production mode)
3. Set security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    match /orders/{orderId} {
      allow read: if request.auth != null &&
        (resource.data.userId == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
      allow create: if request.auth != null;
    }
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

#### Cloud Storage
1. Go to Storage
2. Set security rules for images:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /users/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Stripe Payment Integration

### 1. Create Stripe Account

1. Sign up at [Stripe](https://stripe.com)
2. Complete verification
3. Get API keys from Dashboard

### 2. Backend Setup (Required for Production)

Create a Cloud Function for payment intents:

```javascript
// functions/index.js
const functions = require('firebase-functions');
const stripe = require('stripe')(functions.config().stripe.secret);

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be logged in');
  }

  const { amount, currency = 'usd' } = data;

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // Convert to cents
      currency,
      automatic_payment_methods: { enabled: true },
      metadata: {
        userId: context.auth.uid,
      },
    });

    return {
      clientSecret: paymentIntent.client_secret,
    };
  } catch (error) {
    throw new functions.https.HttpsError('internal', error.message);
  }
});
```

Deploy the function:

```bash
cd functions
npm install
firebase deploy --only functions
```

### 3. Configure Flutter Stripe

Update `android/app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">LUXE</string>
    <string name="stripe_publishable_key">pk_test_...your_key...</string>
    <bool name="enable_stripe_sdk">true</bool>
</resources>
```

## Building for Release

### Android

#### 1. Configure Signing

Create `android/key.properties`:

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=/path/to/your/keystore.jks
```

Create keystore if needed:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

#### 2. Update build.gradle

Update `android/app/build.gradle`:

```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### 3. Build Release APK/AAB

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

Output locations:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### iOS (Optional)

```bash
# Build iOS
flutter build ios --release

# Archive in Xcode
open ios/Runner.xcworkspace
```

## Deployment

### Google Play Store

1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app
3. Fill app details:
   - App name: LUXE
   - Default language: English
   - App or game: App
   - Free or paid: Free

4. Set up app:
   - App access: All functionality available without special access
   - Ads: No, this app doesn't contain ads
   - Content rating: Complete questionnaire
   - Target audience: 18+
   - News apps: No

5. Upload AAB:
   - Go to Production > Create new release
   - Upload `app-release.aab`
   - Add release notes
   - Review and rollout

### Firebase App Distribution (Beta Testing)

```bash
# Install Firebase CLI tools
curl -sL firebase.tools | bash

# Distribute to testers
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app your_app_id \
  --release-notes "Bug fixes and improvements" \
  --groups "testers"
```

## Post-Deployment

### Analytics Setup

Enable Firebase Analytics:

```dart
// In main.dart, ensure analytics is initialized
await FirebaseAnalytics.instance.logAppOpen();
```

### Crashlytics Setup

```dart
// Add to main.dart
FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
```

### Performance Monitoring

```dart
// Add traces for critical operations
final trace = FirebasePerformance.instance.newTrace('checkout_flow');
await trace.start();
// ... checkout logic ...
await trace.stop();
```

## Monitoring & Maintenance

### Check App Health

```bash
# Check for outdated dependencies
flutter pub outdated

# Update dependencies
flutter pub upgrade

# Analyze code
flutter analyze

# Run tests
flutter test
```

### Update Deployment

1. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # version+build
   ```

2. Build new release

3. Upload to Play Console

4. Staged rollout recommended (10% → 50% → 100%)

## Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clean build
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter build appbundle
```

#### Signing Issues
- Verify keystore path and credentials
- Check `key.properties` format
- Ensure keystore file exists

#### Firebase Issues
- Run `flutterfire configure` again
- Check `google-services.json` exists in `android/app/`
- Verify package name matches Firebase project

#### Stripe Issues
- Verify publishable key is correct
- Check backend function is deployed
- Test in test mode before production

### Support Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Stripe Documentation](https://stripe.com/docs)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)

## Security Checklist

- [ ] Use environment variables for API keys
- [ ] Enable Firebase App Check
- [ ] Configure proper Firestore security rules
- [ ] Set up Firebase Authentication properly
- [ ] Use HTTPS for all API calls
- [ ] Implement input validation
- [ ] Add rate limiting on backend
- [ ] Enable ProGuard/R8 for release builds
- [ ] Remove debug logs in production
- [ ] Use secure storage for sensitive data

## Production Checklist

- [ ] Test on multiple device sizes
- [ ] Test on different Android versions
- [ ] Verify all features work
- [ ] Check performance metrics
- [ ] Review analytics implementation
- [ ] Test payment flow end-to-end
- [ ] Verify push notifications (if implemented)
- [ ] Test offline behavior
- [ ] Review accessibility
- [ ] Check dark mode implementation

---

For support, contact: support@luxe.com
