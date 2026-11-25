---
name: project-theme-and-responsive
description: >-
  Enforces the project's Material 3 ColorScheme, ExtendedColors, TextTheme,
  ContextExtension caching pattern, and ResponsiveUIValues/ResponsiveSize tokens.
  Use when styling UI widgets, applying colors or typography, or setting spacing,
  padding, border radii, icon sizes, or elevations.
---

# Project Theme & Responsive System

Use the project's theme, color, typography, and responsive extensions on `BuildContext` for all visual styling.

## 1. Mandatory `BuildContext` Object Caching

At the beginning of every `build` method or widget-builder helper function, bind the needed `ContextExtension` getters to local `final` variables and reference all styles/colors/strings through those variables:

```dart
@override
Widget build(BuildContext context) {
  final textTheme = context.textTheme;
  final colorScheme = context.colorScheme;
  final extendedColors = context.extendedColors;
  final l10n = context.l10n;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.settings,
        style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
      ),
      context.verticalSpace(8),
      Text(
        l10n.error,
        style: textTheme.bodySmall?.copyWith(color: extendedColors.danger.color),
      ),
    ],
  );
}
```

**Do NOT**:
- Call `Theme.of(context).textTheme` or `Theme.of(context).colorScheme` directly.
- Repeat `context.textTheme` / `context.colorScheme` / `context.extendedColors` multiple times inside the same function when a cached `final` variable can be used.

## 2. Color System (`colorScheme` & `extendedColors`)

- **Standard Material 3 roles (`colorScheme`)**: `primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`, `secondary`, `surface`, `onSurface`, `surfaceContainerLow`, `outline`, `outlineVariant`, `error`, etc. (defined in `lib/app/theme/light_theme.dart` and `dark_theme.dart`).
- **Semantic status colors (`extendedColors`)**: `danger`, `warning`, `info`, `success` (defined in `lib/app/theme/extended_colors.dart`). Each `ColorFamily` exposes:
  - `.color`
  - `.onColor`
  - `.colorContainer`
  - `.onColorContainer`
- **Never** hardcode `Color(0x...)` or `Colors.*` for theme-dependent UI. Use `.withValues(alpha: ...)` (not deprecated `.withOpacity(...)`) when adjusting opacity.

## 3. Typography (`textTheme`)

- `MaterialTheme.responsiveTextTheme(context)` is already applied globally in `lib/main.dart` using `AppConstants.fontFamily` (`NotoSansArabic`) and responsive scaling.
- Always pick a role from `textTheme` (`displayLarge/Medium/Small`, `headlineLarge/Medium/Small`, `titleLarge/Medium/Small`, `bodyLarge/Medium/Small`, `labelLarge/Medium/Small`) and customize only via `.copyWith(...)`.
- Never write standalone `TextStyle(fontSize: 16, fontWeight: ...)` from scratch for standard UI text.

## 4. Responsive Spacing, Radii, Icons & Elevations

Import `package:idiomer/core/utils/extensions/responsive_values.dart` (and `responsive_size.dart` if calling `setSize` directly):

- **Spacing**: `context.spaceXxs` (2), `spaceXs` (4), `spaceS` (8), `spaceM` (12), `spaceL` (16), `spaceXl` (24), `spaceXxl` (32), `spaceXxxl` (48), `spaceXxxxl` (64).
- **Space widgets**: `context.verticalSpace(height)` and `context.horizontalSpace(width)` instead of raw `SizedBox(height: ...)` / `SizedBox(width: ...)`.
- **Padding (`EdgeInsets`)**: `context.insetsAllXs..Xxl`, `context.insetsHorizontalXxs..Xl`, `context.insetsVerticalXxs..Xl`.
- **Border Radius**: `context.radiusXs..Xxl`, `context.radiusCircular`, `context.brXs..Xxl`, `context.brCircular`.
- **Icon sizes**: `context.iconXs` (12), `iconS` (16), `iconM` (20), `iconL` (24), `iconXl` (30), `iconXxl` (36).
- **Elevations**: `context.elevationNone`, `elevationS`, `elevationM`, `elevationL`, `elevationXl`.
- **Custom scaled value / screen info**: `context.setSize(value)`, `context.screenWidth`, `context.screenHeight`, `context.isLandScape`.
