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

  /// No description provided for @shareIdiom.
  ///
  /// In en, this message translates to:
  /// **'Share Idiom'**
  String get shareIdiom;

  /// No description provided for @shareViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get shareViaWhatsApp;

  /// No description provided for @saveAsImage.
  ///
  /// In en, this message translates to:
  /// **'Save Image'**
  String get saveAsImage;

  /// No description provided for @shareAsImage.
  ///
  /// In en, this message translates to:
  /// **'Share Image'**
  String get shareAsImage;

  /// No description provided for @shareAsText.
  ///
  /// In en, this message translates to:
  /// **'Share Text'**
  String get shareAsText;

  /// No description provided for @shareOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get shareOther;

  /// No description provided for @imageSaved.
  ///
  /// In en, this message translates to:
  /// **'Image saved successfully'**
  String get imageSaved;

  /// No description provided for @failedToSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Could not save image'**
  String get failedToSaveImage;

  /// No description provided for @failedToShare.
  ///
  /// In en, this message translates to:
  /// **'Failed to share'**
  String get failedToShare;

  /// No description provided for @whatsappUnavailable.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is not available on this device'**
  String get whatsappUnavailable;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @homeMotivationalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Master a new English idiom every day'**
  String get homeMotivationalSubtitle;

  /// No description provided for @idiomOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Idiom of the Day'**
  String get idiomOfTheDay;

  /// No description provided for @dailyQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Idiom Quiz'**
  String get dailyQuizTitle;

  /// No description provided for @quizFirstTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Test yourself with 8 idioms in 2 minutes'**
  String get quizFirstTimeSubtitle;

  /// No description provided for @quizOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} quizzes completed • Avg {avg}%'**
  String quizOverviewSubtitle(int count, int avg);

  /// No description provided for @startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuiz;

  /// No description provided for @viewProgress.
  ///
  /// In en, this message translates to:
  /// **'View Progress'**
  String get viewProgress;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @filterByCategory.
  ///
  /// In en, this message translates to:
  /// **'Filter by category'**
  String get filterByCategory;

  /// No description provided for @quizOverview.
  ///
  /// In en, this message translates to:
  /// **'Quiz Overview'**
  String get quizOverview;

  /// No description provided for @totalQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Total Quizzes'**
  String get totalQuizzes;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get averageScore;

  /// No description provided for @quizHistory.
  ///
  /// In en, this message translates to:
  /// **'Quiz History'**
  String get quizHistory;

  /// No description provided for @newQuiz.
  ///
  /// In en, this message translates to:
  /// **'New Quiz'**
  String get newQuiz;

  /// No description provided for @scoreOutOf.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total}'**
  String scoreOutOf(int correct, int total);

  /// No description provided for @quizAttemptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{correct} out of {total} in {duration}'**
  String quizAttemptSubtitle(int correct, int total, String duration);

  /// No description provided for @secondsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 second} other{{count} seconds}}'**
  String secondsCount(int count);

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String minutesCount(int count);

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionProgress(int current, int total);

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submitQuiz.
  ///
  /// In en, this message translates to:
  /// **'Submit Quiz'**
  String get submitQuiz;

  /// No description provided for @quizQuestionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Which idiom matches this definition?'**
  String get quizQuestionPrompt;

  /// No description provided for @quizCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed!'**
  String get quizCompletedTitle;

  /// No description provided for @timeUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Time\'s Up!'**
  String get timeUpTitle;

  /// No description provided for @completionTime.
  ///
  /// In en, this message translates to:
  /// **'Completion Time'**
  String get completionTime;

  /// No description provided for @yourScore.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get yourScore;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @backToOverview.
  ///
  /// In en, this message translates to:
  /// **'View Overview'**
  String get backToOverview;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @exitQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Quiz?'**
  String get exitQuizTitle;

  /// No description provided for @exitQuizMessage.
  ///
  /// In en, this message translates to:
  /// **'Your current quiz progress will be lost.'**
  String get exitQuizMessage;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @notEnoughIdiomsForQuiz.
  ///
  /// In en, this message translates to:
  /// **'Not enough idioms available to start a quiz.'**
  String get notEnoughIdiomsForQuiz;

  /// No description provided for @noQuizzesYet.
  ///
  /// In en, this message translates to:
  /// **'No Quizzes Completed Yet'**
  String get noQuizzesYet;

  /// No description provided for @noQuizzesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take your first 8-question quiz to track your progress here.'**
  String get noQuizzesSubtitle;

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswers;

  /// No description provided for @unanswered.
  ///
  /// In en, this message translates to:
  /// **'Unanswered'**
  String get unanswered;

  /// No description provided for @correctAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct: {answer}'**
  String correctAnswerLabel(String answer);

  /// No description provided for @addToFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Add to Flashcards'**
  String get addToFlashcards;

  /// No description provided for @savedToGroup.
  ///
  /// In en, this message translates to:
  /// **'Saved to \"{group}\"'**
  String savedToGroup(String group);

  /// No description provided for @alreadyInGroup.
  ///
  /// In en, this message translates to:
  /// **'Already in \"{group}\"'**
  String alreadyInGroup(String group);

  /// No description provided for @changeGroup.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeGroup;

  /// No description provided for @chooseFlashcardGroup.
  ///
  /// In en, this message translates to:
  /// **'Choose Flashcard Group'**
  String get chooseFlashcardGroup;

  /// No description provided for @moveToGroup.
  ///
  /// In en, this message translates to:
  /// **'Move to Group'**
  String get moveToGroup;

  /// No description provided for @movedToGroup.
  ///
  /// In en, this message translates to:
  /// **'Moved to \"{group}\"'**
  String movedToGroup(String group);

  /// No description provided for @removeFromGroup.
  ///
  /// In en, this message translates to:
  /// **'Remove from Group'**
  String get removeFromGroup;

  /// No description provided for @removedFromGroup.
  ///
  /// In en, this message translates to:
  /// **'Removed from group'**
  String get removedFromGroup;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get newGroup;

  /// No description provided for @renameGroup.
  ///
  /// In en, this message translates to:
  /// **'Rename Group'**
  String get renameGroup;

  /// No description provided for @deleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroup;

  /// No description provided for @deleteGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Group?'**
  String get deleteGroupTitle;

  /// No description provided for @deleteGroupMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{group}\" and remove its cards?'**
  String deleteGroupMessage(String group);

  /// No description provided for @clearFlashcardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All Flashcards?'**
  String get clearFlashcardsTitle;

  /// No description provided for @clearFlashcardsMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all flashcard groups and their cards?'**
  String get clearFlashcardsMessage;

  /// No description provided for @flashcardsCleared.
  ///
  /// In en, this message translates to:
  /// **'All flashcards cleared'**
  String get flashcardsCleared;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupName;

  /// No description provided for @groupNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter group name...'**
  String get groupNameHint;

  /// No description provided for @groupAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'A group with this name already exists'**
  String get groupAlreadyExists;

  /// No description provided for @groupCreated.
  ///
  /// In en, this message translates to:
  /// **'Group created'**
  String get groupCreated;

  /// No description provided for @groupRenamed.
  ///
  /// In en, this message translates to:
  /// **'Group renamed'**
  String get groupRenamed;

  /// No description provided for @groupDeleted.
  ///
  /// In en, this message translates to:
  /// **'Group deleted'**
  String get groupDeleted;

  /// No description provided for @idiomsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 idioms} =1{1 idiom} other{{count} idioms}}'**
  String idiomsCount(int count);

  /// No description provided for @studyFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get studyFlashcards;

  /// No description provided for @tapCardToFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap card to reveal translation & meaning'**
  String get tapCardToFlip;

  /// No description provided for @noOtherGroups.
  ///
  /// In en, this message translates to:
  /// **'No other groups available'**
  String get noOtherGroups;

  /// No description provided for @noGroupIdiomsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Idioms in This Group'**
  String get noGroupIdiomsTitle;

  /// No description provided for @noGroupIdiomsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add idioms from Idiom Details or move idioms from another group.'**
  String get noGroupIdiomsSubtitle;

  /// No description provided for @generalGroup.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalGroup;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @flipCard.
  ///
  /// In en, this message translates to:
  /// **'Flip Card'**
  String get flipCard;

  /// No description provided for @shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// No description provided for @imageSavedToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Saved to Downloads/Idiomer'**
  String get imageSavedToDownloads;

  /// No description provided for @readOnlyReview.
  ///
  /// In en, this message translates to:
  /// **'Review Only'**
  String get readOnlyReview;

  /// No description provided for @reviewQuizNotFound.
  ///
  /// In en, this message translates to:
  /// **'Quiz attempt not found'**
  String get reviewQuizNotFound;

  /// No description provided for @takeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take Quiz'**
  String get takeQuiz;

  /// No description provided for @showIdiomsList.
  ///
  /// In en, this message translates to:
  /// **'Show Idioms'**
  String get showIdiomsList;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingIdioms.
  ///
  /// In en, this message translates to:
  /// **'Loading idioms...'**
  String get loadingIdioms;

  /// No description provided for @loadingIdiomDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading idiom...'**
  String get loadingIdiomDetails;

  /// No description provided for @loadingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Loading favorites...'**
  String get loadingFavorites;

  /// No description provided for @loadingFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Loading flashcards...'**
  String get loadingFlashcards;

  /// No description provided for @preparingQuiz.
  ///
  /// In en, this message translates to:
  /// **'Preparing quiz...'**
  String get preparingQuiz;

  /// No description provided for @loadingQuizOverview.
  ///
  /// In en, this message translates to:
  /// **'Loading quizzes...'**
  String get loadingQuizOverview;

  /// No description provided for @loadingQuizReview.
  ///
  /// In en, this message translates to:
  /// **'Loading review...'**
  String get loadingQuizReview;

  /// No description provided for @continueStudying.
  ///
  /// In en, this message translates to:
  /// **'Continue Studying'**
  String get continueStudying;

  /// No description provided for @browseCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get browseCategories;
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
