---
name: project-bloc-clean-architecture
description: >-
  Guides Clean Architecture (Presentation, Domain, Data), flutter_bloc (Bloc vs
  Cubit selection), and get_it dependency injection in idiomer. Use when
  creating or refactoring features, state management, repositories, use cases,
  data sources, or deciding between Bloc, Cubit, and local UI state.
---

# Clean Architecture, BLoC & Dependency Injection

Follow strict Clean Architecture layers (`data/`, `domain/`, `presentation/`), `flutter_bloc` state management, and `get_it` dependency injection (`sl`).

## 1. Clean Architecture Layering (`lib/features/<feature>/`)

Organize every business/data feature into three layers:

```text
lib/features/<feature>/
├── data/
│   ├── datasources/      # Local (SQLite, CashService) or remote data sources
│   ├── models/           # DTOs / persistence models (fromJson/toJson/toEntity)
│   └── repositories/     # Concrete *RepositoryImpl implementing domain contract
├── domain/
│   ├── entities/         # Immutable Equatable business entities
│   ├── repositories/     # Abstract *Repository interfaces
│   └── usecases/         # Focused single-responsibility use cases
└── presentation/
    ├── bloc/ (or cubit/) # Feature Bloc or Cubit + immutable Equatable State (+ Event)
    ├── pages/            # Full-screen route pages (*_page.dart)
    └── widgets/          # Feature-specific UI widgets (never duplicate shared/widgets/)
```

### Dependency Rule
- `presentation` -> depends on `domain` (entities, use cases) only. Never import `data/` implementations or `CashService`/SQLite directly in `presentation/`.
- `data` -> depends on `domain` (implements `domain/repositories/`, maps models to `domain/entities/`).
- `domain` -> pure business contracts and entities. Never import `data/`, `presentation/`, `flutter_bloc`, `go_router`, or storage/HTTP packages.
- **Exception for pure UI/placeholder features**: Features without business logic or data yet (e.g., `app_shell`, placeholder tabs) only need `presentation/pages/` until `domain/` and `data/` are added.

## 2. Choosing Between `Bloc`, `Cubit`, and Local UI State

Choose the simplest mechanism that fits the state's complexity:

| Mechanism | When to Use | Examples in `idiomer` |
| :--- | :--- | :--- |
| **`StatefulNavigationShell`** (`go_router`) | Persistent bottom-tab shell switching and branch stack preservation | `AppShellPage` |
| **`StatefulWidget` / `ChangeNotifier`** (`lib/shared/controller/`) | Ephemeral widget-local UI mechanics (controllers, animations, focus, picker selection) | `ImagePickerController`, `SelectableListController`, `SegmentButtonController`, `SelectableChipListController` |
| **`Cubit<State>`** | Direct method-driven state mutations without complex event stream orchestration: settings/preferences, simple CRUD lists, single-entity toggles, form states, step/card-flip flows | `SettingsCubit` (`changeTheme`, `changeLocale`), future `FavoritesCubit`, future `FlashcardsCubit` (session flip/rate/next) |
| **`Bloc<Event, State>`** | Event-driven workflows needing event transformers (`debounce`, `throttle`, `restartable`, `droppable`), concurrent async race control, multiple event sources mutating shared state, or explicit event logging/analytics/undo | Future `IdiomsBloc` (debounced search-as-you-type + category filter + pagination events) |

### Quick Decision Checklist
Ask these questions before creating a state holder:
1. Is it purely ephemeral widget UI (focus, animation, `TextEditingController`, `StatefulNavigationShell` tab)? -> **Local `StatefulWidget` / `ChangeNotifier` / `StatefulNavigationShell`**.
2. Does it need `debounce`, `throttle`, `restartable` / `droppable` concurrency control, or multi-source event pipelines? -> **Use `Bloc`**.
3. Otherwise (direct UI method calls -> state transitions) -> **Use `Cubit`**.

## 3. Dependency Injection (`get_it`)

All dependencies are registered in `lib/app/di/injection.dart` via `final GetIt sl = GetIt.instance;`:

- **`registerSingleton`**: Pre-initialized core services (e.g., `CashService.instance`).
- **`registerLazySingleton`**: DataSources, Repositories, UseCases, and stateless services.
- **`registerFactory`**: `Bloc` and `Cubit` classes when provided via `BlocProvider(create: (_) => sl<MyCubit>())` so `BlocProvider` safely calls `close()` on disposal without leaving a closed singleton in `get_it`.
- Provide app-wide Cubits/Blocs (such as `SettingsCubit`) at the root `MultiBlocProvider` in `lib/main.dart`.
- Provide feature-scoped Cubits/Blocs in the route builder (`AppRouter`) or page wrapper using `BlocProvider(create: (_) => sl<FeatureBloc>()..add(...))`.

## 4. `Bloc` / `Cubit` Implementation Rules

1. **Immutable `Equatable` States**: Extend `Equatable` on every state (and event) class and provide `copyWith` (or use a Dart 3 `sealed class` hierarchy when loading/loaded/error states have distinct fields).
2. **Targeted Rebuilds**: Use `BlocSelector` or `BlocBuilder(..., buildWhen: ...)` so only widgets affected by changed fields rebuild.
3. **Side Effects via `BlocListener`**: Trigger navigation (`context.go`, `context.push`), `ToastHelper`, `SnackBarHelper`, `DialogHelper`, or `BottomSheetHelper` inside `BlocListener` / `BlocConsumer` or UI callbacks—never hold or pass `BuildContext` inside a `Bloc` or `Cubit`.
4. **Async Safety**: Always check `if (isClosed) return;` after `await` before calling `emit(...)`.
5. **Lifecycle Cleanup**: Cancel any `StreamSubscription`, `Timer`, or controller created inside a `Bloc`/`Cubit` in `@override Future<void> close()`.
