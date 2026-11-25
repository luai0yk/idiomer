# Core Inventory (`lib/core/`)

Inspect the target file if you need optional parameter details.

## Constants (`lib/core/constants/`)
- `AppAssets` (`app_assets.dart`): `appIcon`, `appIconAndroid12`, `branding`, `brandingDark`
- `AppConstants` (`app_constants.dart`): `fontFamily` (`'NotoSansArabic'`), `maxNameLength` (50), `maxPhoneLength` (15), `maxAddressLength` (100), `maxNotesLength` (200), `maxPriceLength` (15)
- `AppDurations` (`app_durations.dart`): `veryFast` (100ms), `fast` (200ms), `medium` (300ms), `slow` (400ms), `verySlow` (500ms)
- `AppIcons` (`app_icons.dart`): Curated `Iconsax` and `Icons` constants + RTL-aware `arrowBack(BuildContext)` and `arrowForward(BuildContext)`

## Services (`lib/core/services/cash/`)
- `CashService` (`cash_service.dart`): `CashService.instance` wrapper over `SharedPreferences`
- `CashKeys` (`cash_keys.dart`): `themeMode`, `languageCode`, `recentColors`

## UI Helpers (`lib/core/utils/helpers/ui/`)
- `AppNavigator` (`app_navigator.dart`): `key`, `currentState`, `context`
- `DialogHelper` (`dialog_helper.dart`): `show(child:, isDismissible:)`, `dismiss()`
- `ProgressDialog` (`progress_dialog.dart`): `show(message:)`, `dismiss()`
- `BottomSheetHelper` (`bottom_sheet_helper.dart`): `show<T>(child:, ...)`, `dismiss<T>(result:)`
- `SnackBarHelper` (`snackbar_helper.dart`): `show(msg:, longSec:, status:, icon:, actionText:, onAction:)`
- `ToastHelper` (`toast_helper.dart`): `show(msg:, longSec:, status:, icon:, actionText:, onAction:, preventDuplication:)`
- `WidgetCaptureHelper` (`widget_capture_helper.dart`)

## Settings & Misc Helpers (`lib/core/utils/helpers/`)
- `SettingsHelper` (`settings_helper.dart`): `currentTheme`, `getThemeName(context, mode)`, `currentLocale`, `currentLangCode`, `isArabic`
- `UrlHelper` (`misc/url_helper.dart`)
- `ShareHelper` (`misc/share_helper.dart`)
- `RecentImageStore` (`misc/recent_image_store.dart`)

## Validators (`lib/core/utils/validators/`)
- `EmptyValidator.validate(AppLocalizations l10n, String? value, {String? msg})`
- `EmailValidator.validate(AppLocalizations l10n, {required String? value})`
- `PhoneValidator.validate(AppLocalizations l10n, String? value, {required String countryCode})`

## Formatters (`lib/core/utils/formatters/`)
- `DateTimeFormatter` (`date_time_formatter.dart`)
- `DecimalInputFormatter` (`decimal_input_formatter.dart`)
