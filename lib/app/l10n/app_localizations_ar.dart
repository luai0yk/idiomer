// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get required => 'مطلوب';

  @override
  String get invalidEmail => 'إيميل غير صالح';

  @override
  String get invalidPhoneNumber => 'رقم هاتف غير صحيح';

  @override
  String get settings => 'الإعدادات';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get ok => 'حسنا';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get dateTime => 'التاريخ والوقت';

  @override
  String get gallery => 'المعرض';

  @override
  String get file => 'ملف';

  @override
  String get camera => 'الكاميرا';

  @override
  String get recentImages => 'الصور الحديثة';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get noRecentImages => 'لا توجد صور حديثة';

  @override
  String get deletedFromRecent => 'تم الحذف من الصور الحديثة';

  @override
  String get clearRecentImagesTitle => 'مسح الصور الحديثة؟';

  @override
  String get clearAllMessage => 'هل أنت متأكد من مسح جميع الصور الحديثة؟';

  @override
  String get clear => 'مسح';

  @override
  String get cancel => 'إلغاء';

  @override
  String get generalSettings => 'التفضيلات';

  @override
  String get theme => 'السمة';

  @override
  String get language => 'اللغة';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get selectTheme => 'اختر المظهر';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get search => 'بحث..';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get tryDifferentSearchTerms => 'جرّب كلمات بحث مختلفة';

  @override
  String get tryAdjustingSearch => 'حاول تعديل كلمات البحث';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get noDataSubtitle => 'لا يوجد شيء لعرضه هنا';

  @override
  String get selectColor => 'اختر لون';

  @override
  String get customColor => 'لون مخصص';

  @override
  String get recentColors => 'الألوان الحديثة';

  @override
  String get invalidFormat => 'تنسيق غير صالح';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get selectDateRange => 'اختر الفترة الزمنية';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get setAsFavorite => 'تعيين كمفضلة';

  @override
  String get removeFavorite => 'إزالة من المفضلة';

  @override
  String get justNow => 'الآن';

  @override
  String get yesterday => 'أمس';

  @override
  String get selectIcon => 'اختر أيقونة';

  @override
  String get idioms => 'التعابير';

  @override
  String get favorites => 'المفضلة';

  @override
  String get flashcards => 'البطاقات';

  @override
  String get noIdiomsTitle => 'لا توجد تعابير بعد';

  @override
  String get noIdiomsSubtitle => 'ستظهر مجموعة التعابير الخاصة بك هنا.';

  @override
  String get noFavoritesTitle => 'لا توجد مفضلات بعد';

  @override
  String get noFavoritesSubtitle =>
      'احفظ التعابير التي تعجبك للوصول إليها بسرعة هنا.';

  @override
  String get noFlashcardsTitle => 'لا توجد بطاقات بعد';

  @override
  String get noFlashcardsSubtitle =>
      'تدرّب وراجع التعابير باستخدام البطاقات هنا.';

  @override
  String get appName => 'Idiomer';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get dbSetupSubtitle => 'جارٍ تجهيز مكتبة التعابير الإنجليزية والعربية';

  @override
  String get dbChecking => 'جارٍ التحقق من قاعدة البيانات المحلية...';

  @override
  String get dbDownloading => 'جارٍ تحميل قاعدة بيانات التعابير...';

  @override
  String get dbExtracting => 'جارٍ استخراج قاعدة البيانات...';

  @override
  String get dbVerifying => 'جارٍ التحقق من سلامة قاعدة البيانات...';

  @override
  String get dbReady => 'جاهز';

  @override
  String get noInternetTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noInternetSubtitle =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى لتحميل قاعدة بيانات التعابير.';

  @override
  String get dbDownloadFailedTitle => 'فشل التحميل';

  @override
  String get dbDownloadFailedSubtitle =>
      'تعذّر تحميل قاعدة بيانات التعابير. يرجى المحاولة مرة أخرى.';

  @override
  String get dbExtractionFailedTitle => 'فشل الاستخراج';

  @override
  String get dbExtractionFailedSubtitle =>
      'تعذّر استخراج الملف المحمّل. يرجى إعادة المحاولة.';

  @override
  String get dbVerificationFailedTitle => 'فشل التحقق من قاعدة البيانات';

  @override
  String get dbVerificationFailedSubtitle =>
      'تبدو قاعدة البيانات المحلية غير مكتملة أو تالفة. يرجى إعادة المحاولة.';

  @override
  String get dbSetupFailedTitle => 'فشل الإعداد';

  @override
  String get dbSetupFailedSubtitle =>
      'حدث خطأ غير متوقع أثناء تجهيز قاعدة البيانات.';

  @override
  String get searchIdiomsHint => 'ابحث في التعابير أو الترجمات أو الأمثلة...';

  @override
  String get allCategories => 'الكل';

  @override
  String get expandCategories => 'عرض جميع التصنيفات';

  @override
  String get collapseCategories => 'طيّ التصنيفات';

  @override
  String get clearFilters => 'مسح الفلاتر';

  @override
  String get loadErrorTitle => 'حدث خطأ ما';

  @override
  String get loadErrorSubtitle =>
      'تعذّر تحميل التعابير حالياً. يرجى المحاولة مرة أخرى.';

  @override
  String get idiomDetails => 'تفاصيل التعبير';

  @override
  String get idiomLabel => 'التعبير';

  @override
  String get translationLabel => 'الترجمة';

  @override
  String get meaningLabel => 'المعنى';

  @override
  String get meaningsLabel => 'المعاني';

  @override
  String get exampleLabel => 'مثال';

  @override
  String get examplesLabel => 'أمثلة';

  @override
  String get notesLabel => 'ملاحظات';

  @override
  String get categoriesLabel => 'التصنيفات';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get copyAll => 'نسخ الكل';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get idiomNotFoundTitle => 'التعبير غير موجود';

  @override
  String get idiomNotFoundSubtitle =>
      'تعذّر تحميل هذا التعبير من قاعدة البيانات.';

  @override
  String get addedToFavorites => 'تمت الإضافة إلى المفضلة';

  @override
  String get removedFromFavorites => 'تمت الإزالة من المفضلة';

  @override
  String get clearFavoritesTitle => 'مسح جميع المفضلات؟';

  @override
  String get clearFavoritesMessage =>
      'هل أنت متأكد من إزالة جميع التعابير المحفوظة من المفضلة؟';

  @override
  String get favoritesCleared => 'تم مسح جميع المفضلات';
}
