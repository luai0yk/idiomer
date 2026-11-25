---
name: project-feature-routing-l10n
description: >-
  Guides scaffolding Clean Architecture features in lib/features/, registering
  go_router routes in lib/app/routes/, wiring get_it dependencies in
  lib/app/di/, and adding localized strings in lib/app/l10n/. Use when creating
  a new page/screen, Bloc/Cubit, route, or adding English and Arabic
  translations.
---

# Project Feature, Routing & Localization

Follow the project's Clean Architecture feature structure, `get_it` registration, `go_router` configuration, and ARB localization workflow.

## 1. Feature Structure (`lib/features/<feature_name>/`)

Refer to `project-bloc-clean-architecture` for full layer rules and choosing `Bloc` vs `Cubit`.

For a feature with data/business logic, create:
- `domain/entities/` — Immutable `Equatable` domain models.
- `domain/repositories/` — Abstract `*Repository` interfaces.
- `domain/usecases/` — Focused use case classes.
- `data/datasources/` — Local/remote data sources (inject `CashService` or DB client via constructor).
- `data/models/` — Data mapping models (when DTO/SQLite mapping differs from entities).
- `data/repositories/` — Concrete `*RepositoryImpl` classes.
- `presentation/cubit/` or `presentation/bloc/` — `Cubit`/`Bloc` + `Equatable` `State` (and `Event` if `Bloc`).
- `presentation/pages/<feature_name>_page.dart` — Screen widget (`StatelessWidget` / `StatefulWidget`).
- `presentation/widgets/` — Feature-local subwidgets (only if `lib/shared/widgets/` does not already provide them).

Register DataSource, Repository, UseCases (`registerLazySingleton`), and Cubit/Bloc (`registerFactory`) in `lib/app/di/injection.dart` (`sl`).

## 2. Routing (`lib/app/routes/`)

1. Add a static route path constant to `AppRoutes` in `lib/app/routes/app_routes.dart`:
   ```dart
   static const String myFeature = '/my-feature';
   ```
2. Register the `GoRoute` (or `StatefulShellBranch` for bottom-nav tabs) inside `AppRouter.createRouter()` in `lib/app/routes/app_router.dart`:
   ```dart
   GoRoute(
     path: AppRoutes.myFeature,
     name: AppRoutes.myFeature,
     builder: (context, state) => BlocProvider(
       create: (_) => sl<MyFeatureCubit>(),
       child: const MyFeaturePage(),
     ),
   ),
   ```
3. Navigate using `go_router` extensions (`context.go(AppRoutes.myFeature)`, `context.push(AppRoutes.myFeature)`, `context.pop()`), never hardcoded route strings or `Get.toNamed`.
4. Keep `navigatorKey: AppNavigator.key` on `GoRouter` so global UI helpers (`DialogHelper`, `BottomSheetHelper`, `ToastHelper`, `SnackBarHelper`) continue to resolve `AppNavigator.context`.

## 3. Localization (`lib/app/l10n/`)

Config is in `l10n.yaml` (`arb-dir: lib/app/l10n/arb`, `template-arb-file: app_en.arb`, `output-dir: lib/app/l10n`).

1. Add every user-facing key to **both** `lib/app/l10n/arb/app_en.arb` and `lib/app/l10n/arb/app_ar.arb`.
2. Regenerate localization classes:
   ```bash
   flutter gen-l10n
   ```
3. Check `lib/app/l10n/untranslated_msg.txt` to confirm no keys are missing in `app_ar.arb`.
4. Access translations in widgets via cached `final l10n = context.l10n;` (`l10n.<key>`). Never hardcode user-visible strings in UI files.
