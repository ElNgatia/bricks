# Project Scaffold

A production-grade Flutter project scaffolding template for multi-tenant business apps.

This scaffold standardizes:
- **Clean Architecture** (Feature-first: `data/`, `domain/`, `presentation/`, `i18n/`)
- **State Management**: [Riverpod 3.x](https://riverpod.dev) with Notifiers and state isolation
- **Type-safe Routing**: [GoRouter](https://pub.dev/packages/go_router) with reactive authentication guards
- **Resilient Networking**: [Dio](https://pub.dev/packages/dio) with layered interceptors (Auth, Client headers, Server time, Logging, and Session Expiry)
- **Internationalization (i18n)**: [Slang](https://pub.dev/packages/slang) with **dynamic runtime terminology overrides** (multi-tenant organisation terminology support)
- **Local Persistence**: [Hive Community Edition](https://pub.dev/packages/hive_ce) with AES encryption via `flutter_secure_storage`
- **Modern Theme System**: Material 3 with custom dual `ThemeExtension` (light and dark mode palette & typography)

---

## 📁 Scaffold Directory Structure

```text
<project_name>/
├── bin/add_feature.dart            # Feature generator (see below)
├── analysis_options.yaml           # Strict Flutter linter with trailing commas preserved
├── slang.yaml                      # Slang i18n configuration (namespaces + overrides enabled)
├── .fvmrc                          # Flutter Version Manager pinned version
├── pubspec.yaml                    # Production dependencies
├── assets/
│   └── images/                     # App icons and imagery
├── lib/
│   ├── main.dart                   # Bootstrap: Firebase, Hive, Riverpod, Slang TranslationProvider
│   ├── app/
│   │   ├── app.dart                # MaterialApp.router with Theme and Terminology listeners
│   │   ├── core/
│   │   │   ├── biometrics/         # local_auth biometric authentication helper
│   │   │   ├── constants/          # AppSpacing, NetworkConstants
│   │   │   ├── errors/             # AppException hierarchy + mapDioException
│   │   │   ├── extensions/         # ContextExtensions (colors, textTheme, t) & NameInitials
│   │   │   ├── network/            # ApiClient, DioProvider, SessionExpiry, PaginationMeta
│   │   │   │   └── interceptors/   # Auth, ClientHeaders, Logger, ServerTime, SessionExpired
│   │   │   ├── time/               # ServerClock synchronization
│   │   │   ├── utils/              # AppLogger, ProviderRetry, Date/Currency/Time Formatters
│   │   │   └── widgets/            # Core AppCard, AppDialogs, AppEmptyState, StatusBadge, TextInput
│   │   ├── i18n/
│   │   │   ├── common_en.i18n.json # Base terms, actions, validation, errors, fields, status
│   │   │   ├── term.dart           # Term model (singular, plural, sentence forms)
│   │   │   ├── terminology.dart    # Dynamic multi-tenant terminology model & override mapper
│   │   │   ├── terminology_local_source.dart  # Offline Hive cache for terminology
│   │   │   ├── terminology_remote_source.dart # Remote fetch from /{org}/terminology
│   │   │   └── terminology_provider.dart      # TerminologyController applying Slang overrides
│   │   ├── router/
│   │   │   └── app_router.dart     # GoRouter with auth redirect guard
│   │   ├── settings/
│   │   │   └── app_settings_local_source.dart # Theme mode and preference persistence
│   │   └── theme/
│   │       ├── foundation/         # AppPalette (raw hex) & AppTypography (Montserrat)
│   │       ├── util/               # AppColorsThemeExtentionV2 (Semantic colors for light/dark)
│   │       ├── theme_extensions.dart # AppColorsExtension (Granular theme tokens)
│   │       ├── theme_notifier.dart # Riverpod ThemeMode notifier
│   │       └── theme_v2.dart       # Material 3 ThemeData builder
│   ├── features/                   # Feature modules
│   │   ├── auth/                   # Authentication workflow (data/domain/i18n/presentation)
│   │   └── home/                   # Dashboard workflow
│   └── hive/
│       ├── hive_service.dart       # Encrypted Hive boxes manager (auth, settings, terminology)
│       └── hive_adapters.dart      # Type adapters
└── test/
    ├── helpers/translations.dart   # Translation test harness
    └── widget_test.dart            # Sample unit and widget tests
```

---

## 🚀 Usage

You can initialize new projects either using **Mason** or using the **Standalone Dart CLI**.

### Option 1: Using Mason (Recommended with `bricks` repo)

1. Add the brick from the repository:
   ```bash
   mason add project_scaffold --git-url https://github.com/ElNgatia/bricks --git-path project_scaffold
   ```
   Or if installed locally:
   ```bash
   mason add project_scaffold --path ./project_scaffold
   ```

2. Make a new project:
   ```bash
   mason make project_scaffold
   ```
   You will be prompted for:
   - `project_name` (e.g. `inventory_app`)
   - `project_description`
   - `org_name` (e.g. `com.company.app`)
   - `api_base_url` (e.g. `https://api.company.com/api/v1`)
   - `features` (e.g. `auth,home,orders`; anything beyond `auth` and `home` is generated with `bin/add_feature.dart`)
   - `use_firebase` (true/false)
   - `use_biometrics` (true/false)

---

### Option 2: Using the Standalone Dart CLI (Zero global setup required)

From the root of this folder, run:
```bash
dart run bin/scaffold.dart
```
This interactive CLI prompts for configuration, applies Mustache templates, generates the project directory, and runs `flutter create` for the target platform runners.

---

## ⚡ Adding New Features / Workflows

Generated projects include `bin/add_feature.dart`. From the project root, generate a new domain feature adhering to the clean architecture and i18n conventions:

```bash
dart run bin/add_feature.dart <feature_name>
```

For example:
```bash
dart run bin/add_feature.dart orders
```

This creates:
- `lib/features/orders/data/datasources/`
- `lib/features/orders/data/models/`
- `lib/features/orders/data/repositories/`
- `lib/features/orders/domain/entities/`
- `lib/features/orders/domain/repositories/orders_repository.dart`
- `lib/features/orders/i18n/orders_en.i18n.json` (camelCase for multi-word features, e.g. `leaveRequests_en.i18n.json`, since slang skips underscored file names)
- `lib/features/orders/presentation/providers/`
- `lib/features/orders/presentation/screens/orders_screen.dart`
- `lib/features/orders/presentation/widgets/`
- `lib/features/orders/orders.dart`

---

## 🌐 Internationalization & Dynamic Terminology

### 1. Translation Files
Translations are split across features:
- `lib/app/i18n/common_en.i18n.json` contains global strings (errors, fields, status, actions).
- `lib/features/<feature>/i18n/<feature>_en.i18n.json` contains feature-specific strings.

Run slang to build translations:
```bash
dart run slang
```

### 2. Runtime Terminology Overrides
In multi-tenant systems, organisations often rename domain terms (e.g., "Customer" vs "Client", "Department" vs "Branch", "Order" vs "Booking").
- The app fetches the current organisation's custom terms from `GET /{org}/terminology` (path set in `NetworkConstants.terminologyPath`). The expected response is:
  ```json
  {
    "data": {
      "version": "a1b2c3",
      "terms": {
        "user": { "singular": "Member", "plural": "Members" },
        "unit": { "singular": "Branch", "plural": "Branches" }
      }
    }
  }
  ```
  Each key under `terms` maps to a translation path in `terminologyPaths` (`lib/app/i18n/terminology.dart`); unknown keys are ignored.
- `TerminologyController` caches them in Hive (`terminologyBox`).
- Slang's `LocaleSettings.overrideTranslationsFromMapSync(...)` replaces matching keys in memory at runtime without app restart or hardcoded forks.

---

## 🛠️ Post-Scaffold Setup

After creating your project:

```bash
cd <project_name>
flutter pub get
dart run slang
dart run build_runner build --delete-conflicting-outputs
flutter run
```

