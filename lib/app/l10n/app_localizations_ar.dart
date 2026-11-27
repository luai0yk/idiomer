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

  @override
  String get shareIdiom => 'مشاركة التعبير';

  @override
  String get shareViaWhatsApp => 'واتساب';

  @override
  String get saveAsImage => 'حفظ كصورة';

  @override
  String get shareAsImage => 'مشاركة كصورة';

  @override
  String get shareAsText => 'مشاركة كنص';

  @override
  String get shareOther => 'أخرى';

  @override
  String get imageSaved => 'تم حفظ الصورة بنجاح';

  @override
  String get failedToSaveImage => 'تعذّر حفظ الصورة';

  @override
  String get failedToShare => 'فشلت المشاركة';

  @override
  String get whatsappUnavailable => 'تطبيق واتساب غير متوفر على هذا الجهاز';

  @override
  String get home => 'الرئيسية';

  @override
  String get explore => 'استكشف';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get homeMotivationalSubtitle => 'أتقن تعبيراً إنجليزياً جديداً كل يوم';

  @override
  String get idiomOfTheDay => 'تعبير اليوم';

  @override
  String get dailyQuizTitle => 'اختبار التعابير';

  @override
  String get quizFirstTimeSubtitle => 'اختبر نفسك في 8 تعابير خلال دقيقتين';

  @override
  String quizOverviewSubtitle(int count, int avg) {
    return 'تم إكمال $count اختبارات • المتوسط $avg%';
  }

  @override
  String get startQuiz => 'ابدأ الاختبار';

  @override
  String get viewProgress => 'عرض التقدم';

  @override
  String get selectCategory => 'اختر التصنيف';

  @override
  String get filterByCategory => 'تصفية حسب التصنيف';

  @override
  String get quizOverview => 'ملخص الاختبارات';

  @override
  String get totalQuizzes => 'إجمالي الاختبارات';

  @override
  String get averageScore => 'متوسط الدرجات';

  @override
  String get quizHistory => 'سجل الاختبارات';

  @override
  String get newQuiz => 'اختبار جديد';

  @override
  String scoreOutOf(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String quizAttemptSubtitle(int correct, int total, String duration) {
    return '$correct من $total في $duration';
  }

  @override
  String secondsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ثانية',
      many: '$count ثانية',
      few: '$count ثوانٍ',
      two: 'ثانيتان',
      one: 'ثانية واحدة',
      zero: '0 ثانية',
    );
    return '$_temp0';
  }

  @override
  String minutesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقيقة',
      many: '$count دقيقة',
      few: '$count دقائق',
      two: 'دقيقتان',
      one: 'دقيقة واحدة',
      zero: '0 دقيقة',
    );
    return '$_temp0';
  }

  @override
  String questionProgress(int current, int total) {
    return 'السؤال $current من $total';
  }

  @override
  String get previous => 'السابق';

  @override
  String get next => 'التالي';

  @override
  String get submitQuiz => 'تأكيد الإجابات';

  @override
  String get quizQuestionPrompt => 'أي تعبير يطابق هذا التعريف؟';

  @override
  String get quizCompletedTitle => 'تم إكمال الاختبار!';

  @override
  String get timeUpTitle => 'انتهى الوقت!';

  @override
  String get completionTime => 'وقت الإنجاز';

  @override
  String get yourScore => 'نتيجتك';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get backToOverview => 'عرض الملخص';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get exitQuizTitle => 'مغادرة الاختبار؟';

  @override
  String get exitQuizMessage => 'سيتم فقدان تقدمك الحالي في الاختبار.';

  @override
  String get leave => 'مغادرة';

  @override
  String get stay => 'البقاء';

  @override
  String get notEnoughIdiomsForQuiz => 'لا توجد تعابير كافية لبدء الاختبار.';

  @override
  String get noQuizzesYet => 'لم تكمل أي اختبار بعد';

  @override
  String get noQuizzesSubtitle => 'خض أول اختبار من 8 أسئلة لمتابعة تقدمك هنا.';

  @override
  String get reviewAnswers => 'مراجعة الإجابات';

  @override
  String get unanswered => 'لم تتم الإجابة';

  @override
  String correctAnswerLabel(String answer) {
    return 'الصحيح: $answer';
  }

  @override
  String get addToFlashcards => 'إضافة إلى البطاقات';

  @override
  String savedToGroup(String group) {
    return 'تم الحفظ في \"$group\"';
  }

  @override
  String alreadyInGroup(String group) {
    return 'موجود بالفعل في \"$group\"';
  }

  @override
  String get changeGroup => 'تغيير';

  @override
  String get chooseFlashcardGroup => 'اختر مجموعة البطاقات';

  @override
  String get moveToGroup => 'نقل إلى مجموعة';

  @override
  String movedToGroup(String group) {
    return 'تم النقل إلى \"$group\"';
  }

  @override
  String get removeFromGroup => 'إزالة من المجموعة';

  @override
  String get removedFromGroup => 'تمت الإزالة من المجموعة';

  @override
  String get createGroup => 'إنشاء مجموعة';

  @override
  String get newGroup => 'مجموعة جديدة';

  @override
  String get renameGroup => 'إعادة تسمية المجموعة';

  @override
  String get deleteGroup => 'حذف المجموعة';

  @override
  String get deleteGroupTitle => 'حذف المجموعة؟';

  @override
  String deleteGroupMessage(String group) {
    return 'هل أنت متأكد من حذف \"$group\" وإزالة بطاقاتها؟';
  }

  @override
  String get clearFlashcardsTitle => 'مسح جميع البطاقات؟';

  @override
  String get clearFlashcardsMessage =>
      'هل أنت متأكد من حذف جميع مجموعات البطاقات وبطاقاتها؟';

  @override
  String get flashcardsCleared => 'تم مسح جميع البطاقات';

  @override
  String get groupName => 'اسم المجموعة';

  @override
  String get groupNameHint => 'أدخل اسم المجموعة...';

  @override
  String get groupAlreadyExists => 'توجد مجموعة بهذا الاسم بالفعل';

  @override
  String get groupCreated => 'تم إنشاء المجموعة';

  @override
  String get groupRenamed => 'تمت إعادة تسمية المجموعة';

  @override
  String get groupDeleted => 'تم حذف المجموعة';

  @override
  String idiomsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تعبير',
      many: '$count تعبيراً',
      few: '$count تعابير',
      two: 'تعبيران',
      one: 'تعبير واحد',
      zero: '0 تعابير',
    );
    return '$_temp0';
  }

  @override
  String get studyFlashcards => 'دراسة';

  @override
  String get tapCardToFlip => 'اضغط على البطاقة لإظهار الترجمة والمعنى';

  @override
  String get noOtherGroups => 'لا توجد مجموعات أخرى';

  @override
  String get noGroupIdiomsTitle => 'لا توجد تعابير في هذه المجموعة';

  @override
  String get noGroupIdiomsSubtitle =>
      'أضف تعابير من صفحة التفاصيل أو انقل تعابير من مجموعة أخرى.';

  @override
  String get generalGroup => 'عام';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get create => 'إنشاء';

  @override
  String get flipCard => 'اقلب البطاقة';

  @override
  String get shuffle => 'خلط';

  @override
  String get imageSavedToDownloads => 'تم الحفظ في Downloads/Idiomer';

  @override
  String get readOnlyReview => 'للمراجعة فقط';

  @override
  String get reviewQuizNotFound => 'لم يتم العثور على الاختبار';

  @override
  String get takeQuiz => 'إجراء اختبار';

  @override
  String get showIdiomsList => 'عرض التعبيرات';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get loadingIdioms => 'جارٍ تحميل التعابير...';

  @override
  String get loadingIdiomDetails => 'جارٍ تحميل التعبير...';

  @override
  String get loadingFavorites => 'جارٍ تحميل المفضلة...';

  @override
  String get loadingFlashcards => 'جارٍ تحميل البطاقات...';

  @override
  String get preparingQuiz => 'جارٍ تجهيز الاختبار...';

  @override
  String get loadingQuizOverview => 'جارٍ تحميل الاختبارات...';

  @override
  String get loadingQuizReview => 'جارٍ تحميل المراجعة...';

  @override
  String get continueStudying => 'مواصلة الدراسة';

  @override
  String get browseCategories => 'تصفح التصنيفات';
}
