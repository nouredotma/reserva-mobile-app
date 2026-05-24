# Reserva Mobile

![Reserva Logo](assets/images/logo.png)

Reserva Mobile is the Flutter Android/iOS client for the Reserva product.

This project mirrors the Reserva web product flow while using in-project mock data for development.

## Current Project Status

- App shell and navigation are implemented
- Splash preloader is implemented with Reserva branding
- Home, Search, Detail, Booking, Account, and Reviews flows are implemented
- Category-specific booking fields are implemented
- Map section with marker clustering is implemented in Search
- Auth session/login gate is implemented for booking protection
- Mock data is local to this project (Dart source), not remote API

## Tech Stack

- Flutter (Material 3)
- Riverpod (state management)
- go_router (navigation)
- flutter_map + flutter_map_marker_cluster (map rendering + clustering)
- shared_preferences (local session persistence)

## Key Features

- Branded animated splash/preloader
- Bottom-tab app shell
- Search with filters (query, city, category)
- Map view for search results with clustered markers
- Establishment detail page with services and reviews
- Booking flow with category-specific form fields
- Login-required booking confirmation
- Bookings list and account session controls
- Local review submission flow

## Data Source

The app currently uses local Dart mock data:

- `lib/core/data/mock/mock_data.dart`
- `lib/core/repositories/mock_reserva_repository.dart`

This is intentional for current development. There is no backend dependency yet.

## Project Structure

- `lib/app/` - app bootstrap, router, theme
- `lib/core/` - config, auth session, models, providers, repositories, assets
- `lib/features/` - feature modules (splash, home, search, detail, booking, account, reviews, auth, shell)
- `assets/images/` - logo, icon, preloader textures
- `env/` - local runtime defines for development

## Mapbox Setup (Local)

Mapbox token is injected at build/run time via Dart defines.

1. Create/update `env/local.json` from `env/local.example.json`
2. Put your token in `MAPBOX_ACCESS_TOKEN`
3. Run/build with `--dart-define-from-file=env/local.json`

`env/local.json` is gitignored and should never be committed.

## Run

```bash
flutter pub get
flutter run --dart-define-from-file=env/local.json
```

## Build APK

```bash
flutter build apk --release --dart-define-from-file=env/local.json
```

## Notes

- This project targets Android and iOS.
- Some Flutter template platform folders may still exist, but mobile app work is focused on Android/iOS.
- If you run `flutter clean`, run `flutter pub get` before building again.
