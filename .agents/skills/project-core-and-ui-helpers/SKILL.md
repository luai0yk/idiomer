---
name: project-core-and-ui-helpers
description: >-
  Provides procedures and inventory for lib/core/ utilities: UI overlay helpers
  (DialogHelper, BottomSheetHelper, ProgressDialog, SnackBarHelper, ToastHelper,
  AppNavigator), constants (AppIcons, AppDurations, AppConstants, AppAssets),
  validators, formatters, misc helpers, and CashService persistence. Use when
  showing dialogs/sheets/toasts/snackbars, validating or formatting input, using
  icons/durations/assets, launching URLs, sharing, or reading/writing cached settings.
---

# Project Core & UI Helpers

Always use existing `lib/core/` helpers, constants, services, validators, and formatters instead of writing custom replacements or calling raw Flutter overlay/storage APIs.

See [core-inventory.md](./references/core-inventory.md) for the full list of classes and methods, and read the target source file before calling any helper/validator/formatter to verify its exact parameters and return type—never guess signatures.

## Rules

1. **Overlays & Feedback (`lib/core/utils/helpers/ui/`)**:
   - **Dialogs**: Call `DialogHelper.show(child: MyDialog(...))` and `DialogHelper.dismiss()`. Never call `showDialog` or `showGeneralDialog` directly.
   - **Loading**: Call `ProgressDialog.show(message: ...)` and `ProgressDialog.dismiss()`.
   - **Bottom Sheets**: Call `BottomSheetHelper.show<T>(child: MyBottomSheet(...))` and `BottomSheetHelper.dismiss()`. Never call `showModalBottomSheet` directly.
   - **SnackBars**: Call `SnackBarHelper.show(msg: ..., status: SnackBarStatus.*)`. Never call `ScaffoldMessenger.of(context).showSnackBar` directly.
   - **Toasts**: Call `ToastHelper.show(msg: ..., status: ToastStatus.*)`.
   - **Global Navigation Context**: Use `AppNavigator.key`, `AppNavigator.context`, `AppNavigator.currentState`.

2. **Constants (`lib/core/constants/`)**:
   - **Icons**: Use `AppIcons.*` (including `AppIcons.arrowBack(context)` and `AppIcons.arrowForward(context)` for RTL-aware arrows). Do not import `Iconsax` or use `Icons.*` directly in features.
   - **Durations**: Use `AppDurations.veryFast` (100ms), `fast` (200ms), `medium` (300ms), `slow` (400ms), `verySlow` (500ms).
   - **Input Limits & Font**: Use `AppConstants.maxNameLength`, `maxPhoneLength`, `maxAddressLength`, `maxNotesLength`, `maxPriceLength`, `fontFamily`.
   - **Assets**: Add and reference asset paths via `AppAssets`.

3. **Validators & Formatters**:
   - Use `EmptyValidator.validate(l10n, value)`, `EmailValidator.validate(l10n, value: value)`, and `PhoneValidator.validate(l10n, value, countryCode: ...)` for form validation.
   - Use `DecimalInputFormatter` and `DateTimeFormatter` for formatting.

4. **Storage & Settings**:
   - Use `CashService` (via `sl<CashService>()` in `data/` layers or `CashService.instance` in `core/`/`shared/` helpers) with keys defined in `CashKeys` instead of calling `SharedPreferences` directly.
   - Use `SettingsHelper` (`currentTheme`, `getThemeName`, `currentLocale`, `currentLangCode`, `isArabic`) for reading/formatting theme and locale helpers; mutate app theme/locale state through `SettingsCubit`.

5. **Misc Helpers (`lib/core/utils/helpers/misc/`)**:
   - Use `UrlHelper`, `ShareHelper`, `RecentImageStore`, and `WidgetCaptureHelper` instead of calling `url_launcher` or `share_plus` directly in features.
