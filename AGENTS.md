# Project Rules (`idiomer`)

These rules apply to the entire `idiomer` workspace. Follow them strictly whenever reading, creating, or modifying code.

## 1. Architecture & Directory Responsibilities

- `lib/app/`: App-level configuration — `di/` (`injection.dart` with `get_it` `sl`), `l10n/` (`app_en.arb`, `app_ar.arb`, `AppLocalizations`, `AppLocales`, `AppLocaleConfig`), `routes/` (`AppRoutes`, `AppRouter` using `go_router`), and `theme/` (`MaterialTheme`, `lightColorScheme`, `darkColorScheme`, `ExtendedColors`).
- `lib/core/`: Core infrastructure — `constants/` (`AppAssets`, `AppConstants`, `AppDurations`, `AppIcons`), `services/cash/` (`CashService`, `CashKeys`), `utils/extensions/` (`ContextExtension`, `ResponsiveSize`, `ResponsiveUIValues`), `utils/formatters/`, `utils/helpers/` (`SettingsHelper`, `misc/`, `ui/`), and `utils/validators/`.
- `lib/shared/`: Reusable UI components (`lib/shared/widgets/`) and reusable `ChangeNotifier` widget controllers (`lib/shared/controller/`).
- `lib/features/`: Feature modules following **Clean Architecture** (`data/`, `domain/`, `presentation/`):
  - `data/`: `datasources/`, `models/`, `repositories/` (`*RepositoryImpl`).
  - `domain/`: `entities/`, `repositories/` (abstract interfaces), `usecases/`.
  - `presentation/`: `bloc/` or `cubit/`, `pages/`, `widgets/`.
  - Pure UI/placeholder features without data/domain logic yet only need `presentation/pages/`.

## 2. Mandatory Reuse — No Duplicate Widgets or Raw Replacements

- **Always use project custom widgets** from `lib/shared/widgets/` and UI helpers from `lib/core/utils/helpers/ui/`.
- **Do NOT use raw Flutter/Material widgets** when a customized project equivalent exists (for example: use `MyButton` instead of `ElevatedButton`/`OutlinedButton`/`TextButton`, `MyAppBar` instead of `AppBar`, `MyCard` instead of `Card`, `MyTextField` instead of `TextField`/`TextFormField`, `MyDialog` + `DialogHelper` instead of `AlertDialog` + `showDialog`, `MyBottomSheet` + `BottomSheetHelper` instead of `showModalBottomSheet`, `MyImage` instead of `Image.network`/`Image.asset`/`Image.file`, `MyListTile` instead of `ListTile`, etc.).
- **Do NOT create a new widget** in a feature or in `lib/shared/widgets/` if an existing widget in `lib/shared/widgets/` already covers or can be configured for the use case.
- **Always use existing `lib/core/` and `lib/app/` utilities** (`AppIcons`, `AppDurations`, `AppConstants`, `AppAssets`, `CashService`, `CashKeys`, `SettingsHelper`, validators, formatters, misc helpers, `AppRoutes`, `AppRouter`, `sl`, `l10n`) instead of reimplementing them or hardcoding raw values.
- **Verify actual APIs before using them**: Always read the target file in `lib/shared/`, `lib/core/`, or `lib/app/` to confirm exact class names, named constructors, parameters, and return types—never guess or assume an API signature.

## 3. Theme, Color System, `TextTheme`, and `BuildContext` Caching

- **Use the project theme & color system** via `ContextExtension` (`lib/core/utils/extensions/context_extension.dart`):
  - `context.colorScheme` for Material 3 surface/brand/outline/error colors (`primary`, `onPrimary`, `surface`, `onSurface`, `surfaceContainer*`, `outlineVariant`, etc.).
  - `context.extendedColors` (`ExtendedColors`: `danger`, `warning`, `info`, `success`, each with `.color`, `.onColor`, `.colorContainer`, `.onColorContainer`) for semantic status colors.
  - `context.textTheme` for all text styles (`display*`, `headline*`, `title*`, `body*`, `label*`).
  - **Never** hardcode `Color(0x...)`, `Colors.*` (for themeable UI), or raw `TextStyle(fontSize: ..., fontFamily: ...)` when `colorScheme`, `extendedColors`, or `textTheme` applies.
- **Cache `context` objects at the start of every `build` / widget-builder method**:
  Declare local `final` variables at the top of the function and access properties through those variables instead of repeating `context.textTheme` / `Theme.of(context)` / `context.colorScheme` inline:
  ```dart
  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final extendedColors = context.extendedColors;
    final l10n = context.l10n;

    return Text(
      l10n.settings,
      style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
    );
  }
  ```

## 4. Responsive Sizing, Spacing, Icons & Durations

- Use `ResponsiveUIValues` (`context.spaceS/M/L`, `context.insetsAllM`, `context.brM`, `context.iconM`, `context.verticalSpace(...)`, `context.horizontalSpace(...)`) and `ResponsiveSize` (`context.setSize(...)`) instead of hardcoded pixel padding, margins, radii, or `SizedBox` gaps.
- Use `AppIcons` (including RTL-aware `AppIcons.arrowBack(context)` and `AppIcons.arrowForward(context)`) instead of raw `Icons.*` or `Iconsax.*`.
- Use `AppDurations` (`veryFast`, `fast`, `medium`, `slow`, `verySlow`) instead of inline `Duration(milliseconds: ...)`.

## 5. State Management, DI & `setState` Rebuild Scope

- **Use `flutter_bloc` (`Bloc` / `Cubit`)** for feature and app state, and **`get_it` (`sl` in `lib/app/di/injection.dart`)** for dependency injection.
- **Choose `Bloc` vs `Cubit` deliberately** (see `project-bloc-clean-architecture` skill):
  - Use **`Cubit`** for straightforward direct method-driven state mutations (e.g., `SettingsCubit`, toggles, simple CRUD, step/flashcard progression).
  - Use **`Bloc`** when event transformations (`debounce`, `throttle`, `restartable`, `droppable`), concurrent async event orchestration, or multi-source event pipelines are needed (e.g., debounced search + filter + pagination).
  - Keep widget-local ephemeral UI state in small `StatefulWidget`s, `ValueNotifier` / `ValueListenableBuilder`, `lib/shared/controller/` `ChangeNotifier`s, or `go_router`'s `StatefulNavigationShell`.
- **Do NOT use `setState` for large rebuilds** (keep the rebuilt `build` scope to a **maximum of 75–100 lines**). Use `BlocSelector` / `BlocBuilder` (`buildWhen`) for targeted rebuilds.
- **Keep side effects out of `build` and `Bloc`/`Cubit`**: Trigger navigation, `ToastHelper`, `SnackBarHelper`, `DialogHelper`, and `BottomSheetHelper` from `BlocListener` / `BlocConsumer` or UI event callbacks—never pass `BuildContext` into a `Bloc` or `Cubit`.

## 6. Clean Architecture, Code Quality & Documentation

- **Clean Architecture & Dependency Rule**: Enforce `presentation` -> `domain` <- `data`. Keep UI (`presentation/pages/`, `presentation/widgets/`), state (`presentation/bloc|cubit/`), business contracts (`domain/`), and storage/API/DB access (`data/`, `core/services/`) strictly decoupled. `domain/` must never import `data/`, `presentation/`, `flutter_bloc`, `go_router`, or storage packages.
- **Reusable Files**: Extract shared logic, models, or helpers into focused, reusable files instead of duplicating code across features (always check `lib/shared/` and `lib/core/` first).
- **No Large Functions**: Keep functions and `build` methods small, focused, and single-purpose with shallow nesting and early returns; split large methods into well-named private helpers or small focused widgets.
- **Concise Explanations for Complex Code**: Add brief inline comments explaining *why* (not *what*) for non-obvious, tricky, or complex logic.

## 7. Localization, RTL & Routing

- Put all user-facing strings in `lib/app/l10n/arb/app_en.arb` and `lib/app/l10n/arb/app_ar.arb`, regenerate with `flutter gen-l10n`, and access via `l10n` (`context.l10n`).
- **RTL-safe layouts**: Use `EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start`, and `AppIcons.arrowBack(context)` / `AppIcons.arrowForward(context)` instead of hardcoded `left`/`right`. Avoid fixed dimensions on text containers so English/Arabic translations never clip or overflow.
- Register all routes in `lib/app/routes/app_routes.dart` (`AppRoutes`) and `lib/app/routes/app_router.dart` (`AppRouter` using `go_router`). Navigate with `context.go(...)` / `context.push(...)` / `context.pop()`.

## 8. Production Reliability, Performance & Verification

- **Async Safety & Error Handling**: Never swallow exceptions silently (`catch (_) {}`); surface user-facing feedback via `ToastHelper`, `SnackBarHelper`, or an error state. Always guard `BuildContext` after `await` with `if (!context.mounted) return;` and check `if (isClosed) return;` before `emit(...)` in `Bloc`/`Cubit` async callbacks.
- **Lifecycle Disposal**: Always dispose `TextEditingController`, `ScrollController`, `FocusNode`, `AnimationController`, and `StreamSubscription`s in `close()` (`Bloc`/`Cubit`) or `dispose()` (`State`).
- **All UI States**: Every data-driven view must handle **loading** (`MyProgressIndicator` / `Skeletonizer`), **empty** (`MyEmptyState`), and **error/retry** states—not just the happy path.
- **Performance**: Use `ListView.builder` / `SliverList.builder` for dynamic or long lists, prefer `const` widgets, and use targeted `BlocSelector` / `buildWhen` rebuilds.
- **Security & Hygiene**: Never hardcode API keys, tokens, or secrets in `lib/`; guard any debug-only logging with `kDebugMode`.
- **Verification Gate**: Before finishing any change, run `flutter analyze` (zero warnings/errors), `flutter test`, and `flutter gen-l10n` (if `.arb` files changed).

## 9. Project Skills (Read on Demand)

Activate the matching skill in `.agents/skills/` for task-specific details:
- `project-bloc-clean-architecture`: Structuring `data/`/`domain/`/`presentation/`, choosing `Bloc` vs `Cubit` vs local state, and registering dependencies in `get_it`.
- `project-shared-widgets`: Choosing and configuring `lib/shared/widgets/` and `lib/shared/controller/` instead of raw Flutter widgets.
- `project-theme-and-responsive`: Applying `colorScheme`, `extendedColors`, `textTheme`, `context` caching, and `ResponsiveUIValues` / `ResponsiveSize`.
- `project-core-and-ui-helpers`: Using `lib/core/` helpers (`DialogHelper`, `BottomSheetHelper`, `ToastHelper`, `SnackBarHelper`, `ProgressDialog`), constants, validators, formatters, and `CashService`.
- `project-feature-routing-l10n`: Creating new features, `go_router` routes, `get_it` bindings, and adding ARB localizations.
