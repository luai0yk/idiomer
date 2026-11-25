import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmail;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid Phone Number'**
  String get invalidPhoneNumber;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @recentImages.
  ///
  /// In en, this message translates to:
  /// **'Recent Images'**
  String get recentImages;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @noRecentImages.
  ///
  /// In en, this message translates to:
  /// **'No recent images'**
  String get noRecentImages;

  /// No description provided for @deletedFromRecent.
  ///
  /// In en, this message translates to:
  /// **'Deleted from recent'**
  String get deletedFromRecent;

  /// No description provided for @clearRecentImagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Recent Images?'**
  String get clearRecentImagesTitle;

  /// No description provided for @clearAllMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all recent images?'**
  String get clearAllMessage;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get generalSettings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search..'**
  String get search;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryDifferentSearchTerms.
  ///
  /// In en, this message translates to:
  /// **'Try different search terms'**
  String get tryDifferentSearchTerms;

  /// No description provided for @tryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting search terms'**
  String get tryAdjustingSearch;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @noDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'There is nothing to show here'**
  String get noDataSubtitle;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @customColor.
  ///
  /// In en, this message translates to:
  /// **'Custom Color'**
  String get customColor;

  /// No description provided for @recentColors.
  ///
  /// In en, this message translates to:
  /// **'Recent Colors'**
  String get recentColors;

  /// No description provided for @invalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid Format'**
  String get invalidFormat;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @setAsFavorite.
  ///
  /// In en, this message translates to:
  /// **'Set as Favorite'**
  String get setAsFavorite;

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove Favorite'**
  String get removeFavorite;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @idioms.
  ///
  /// In en, this message translates to:
  /// **'Idioms'**
  String get idioms;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// No description provided for @noIdiomsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Idioms Yet'**
  String get noIdiomsTitle;

  /// No description provided for @noIdiomsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your idioms collection will appear here.'**
  String get noIdiomsSubtitle;

  /// No description provided for @noFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Favorites Yet'**
  String get noFavoritesTitle;

  /// No description provided for @noFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save idioms you love to find them quickly here.'**
  String get noFavoritesSubtitle;

  /// No description provided for @noFlashcardsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Flashcards Yet'**
  String get noFlashcardsTitle;

  /// No description provided for @noFlashcardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practice and review idioms with flashcards here.'**
  String get noFlashcardsSubtitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Idiomer'**
  String get appName;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @dbSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preparing your English–Arabic idioms library'**
  String get dbSetupSubtitle;

  /// No description provided for @dbChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking local database...'**
  String get dbChecking;

  /// No description provided for @dbDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading idioms database...'**
  String get dbDownloading;

  /// No description provided for @dbExtracting.
  ///
  /// In en, this message translates to:
  /// **'Extracting database...'**
  String get dbExtracting;

  /// No description provided for @dbVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying database...'**
  String get dbVerifying;

  /// No description provided for @dbReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get dbReady;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again to download the idioms database.'**
  String get noInternetSubtitle;

  /// No description provided for @dbDownloadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Download Failed'**
  String get dbDownloadFailedTitle;

  /// No description provided for @dbDownloadFailedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t download the idioms database. Please try again.'**
  String get dbDownloadFailedSubtitle;

  /// No description provided for @dbExtractionFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Extraction Failed'**
  String get dbExtractionFailedTitle;

  /// No description provided for @dbExtractionFailedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Could not extract the downloaded archive. Please retry.'**
  String get dbExtractionFailedSubtitle;

  /// No description provided for @dbVerificationFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Database Verification Failed'**
  String get dbVerificationFailedTitle;

  /// No description provided for @dbVerificationFailedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The local database appears incomplete or corrupted. Please retry.'**
  String get dbVerificationFailedSubtitle;

  /// No description provided for @dbSetupFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Failed'**
  String get dbSetupFailedTitle;

  /// No description provided for @dbSetupFailedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred while preparing the database.'**
  String get dbSetupFailedSubtitle;

  /// No description provided for @searchIdiomsHint.
  ///
  /// In en, this message translates to:
  /// **'Search idioms, translations, or examples...'**
  String get searchIdiomsHint;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @expandCategories.
  ///
  /// In en, this message translates to:
  /// **'Show all categories'**
  String get expandCategories;

  /// No description provided for @collapseCategories.
  ///
  /// In en, this message translates to:
  /// **'Collapse categories'**
  String get collapseCategories;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @loadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get loadErrorTitle;

  /// No description provided for @loadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load idioms right now. Please try again.'**
  String get loadErrorSubtitle;

  /// No description provided for @idiomDetails.
  ///
  /// In en, this message translates to:
  /// **'Idiom Details'**
  String get idiomDetails;

  /// No description provided for @idiomLabel.
  ///
  /// In en, this message translates to:
  /// **'Idiom'**
  String get idiomLabel;

  /// No description provided for @translationLabel.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translationLabel;

  /// No description provided for @meaningLabel.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaningLabel;

  /// No description provided for @meaningsLabel.
  ///
  /// In en, this message translates to:
  /// **'Meanings'**
  String get meaningsLabel;

  /// No description provided for @exampleLabel.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get exampleLabel;

  /// No description provided for @examplesLabel.
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get examplesLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @categoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesLabel;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copyAll.
  ///
  /// In en, this message translates to:
  /// **'Copy All'**
  String get copyAll;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @idiomNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Idiom Not Found'**
  String get idiomNotFoundTitle;

  /// No description provided for @idiomNotFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This idiom could not be loaded from the database.'**
  String get idiomNotFoundSubtitle;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @clearFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All Favorites?'**
  String get clearFavoritesTitle;

  /// No description provided for @clearFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all saved idioms from your favorites?'**
  String get clearFavoritesMessage;

  /// No description provided for @favoritesCleared.
  ///
  /// In en, this message translates to:
  /// **'All favorites cleared'**
  String get favoritesCleared;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
