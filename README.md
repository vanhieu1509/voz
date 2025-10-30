# voz forum app

A Flutter 3.x application that delivers a native experience for browsing [voz.vn](https://voz.vn) on Android and iOS. The codebase follows Clean Architecture with feature-first folders, uses Riverpod for state management, and integrates FCM for thread notifications.

## Features
- Login with secure cookie storage.
- Browse forums, hot/new threads, infinite scrolling placeholder.
- Thread detail view with reply composer.
- Search threads and authors.
- Watch threads with FCM topic subscription (stub).
- Settings for theme, typography, and data usage toggles.
- Offline cache scaffolding with Drift.
- In-app web view fallback.

## Getting started

### Prerequisites
- Flutter 3.16 or later with Dart SDK >= 3.3.0
- Firebase project for push notifications
- Imgur (or equivalent) API key for image uploads

### Environment variables
Configure runtime values via `--dart-define-from-file=.env` (do **not** commit the real file). A template is included:

```bash
cp .env.example .env
```

Edit `.env` and set:

- `VOZ_BASE_URL` – voz.vn base URL (default already provided)
- `IMG_UPLOAD_ENDPOINT` & `IMG_API_KEY` – image upload integration
- `FCM_*` – Firebase credentials as needed by the mobile platforms

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run --dart-define-from-file=.env
```

For Android, place `android/app/google-services.json`. For iOS, place `ios/Runner/GoogleService-Info.plist` and enable Push Notifications, Background Modes (Remote notifications), and App Groups if queuing uploads.

### Build

```bash
flutter build apk --dart-define-from-file=.env
flutter build ios --no-codesign --dart-define-from-file=.env
```

### Testing

```bash
flutter test
```

### Firebase Cloud Messaging
1. Create a Firebase project and enable Cloud Messaging.
2. Register Android and iOS apps, download the configuration files, and add them to the respective platform directories.
3. Enable background message handlers per FlutterFire documentation.

### App icon and splash
Use `flutter_launcher_icons` and `flutter_native_splash` (add to `dev_dependencies` if customizing) then run:

```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

## Legal & compliance
- Respect voz.vn robots.txt and terms. The networking layer is abstracted to allow API usage or HTML parsing with rate limiting.
- Enhanced fetching can be disabled via future settings toggle.
- Session cookies stored with `flutter_secure_storage`, never logged.

## Project structure
```
lib/
  core/        # networking, theming, parsers, services, database
  features/    # feature-first modules (auth, forums, threads, search, notifications, settings)
  shared/      # localization, router, global providers
assets/        # icons, fonts
```

## TODO
- Bookmark threads offline with advanced TTL policies.
- Multi-account switching with secure profile storage.
- User-level filtering and muting tools.

## QA checklist (pre-release)
- [ ] Flutter analyzer / very_good_analysis passes with no warnings
- [ ] Widget tests and unit tests green, coverage ≥ 70%
- [ ] Login, browse, compose flows verified on Android & iOS
- [ ] Push notifications received for watched threads
- [ ] Offline reading cache validated (airplane mode)
- [ ] Accessibility audit (text scaling, semantics, contrast)
- [ ] Performance profiled (60 FPS lists, memory footprint)
- [ ] Privacy review (no sensitive logging, cookie storage encrypted)

## License
This project is released under the MIT License (see [LICENSE](LICENSE)).
