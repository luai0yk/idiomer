class AppRoutes {
  AppRoutes._();

  static const String dbSetup = '/setup';
  static const String home = '/home';
  static const String idioms = '/idioms';
  static const String favorites = '/favorites';
  static const String flashcards = '/flashcards';
  static const String flashcardStudy = '/flashcards/study';
  static const String quizOverview = '/quiz';
  static const String quizSession = '/quiz/session';
  static const String quizReview = '/quiz/review';
  static const String settings = '/settings';
  static const String idiomDetail = '/idiom';

  static String idiomDetailPath(int id) => '$idiomDetail/$id';
  static String idiomsCategoryPath(String categoryId) =>
      Uri(path: idioms, queryParameters: {'categoryId': categoryId}).toString();
  static String flashcardStudyPath(int id) => '$flashcardStudy/$id';
  static String groupQuizSessionPath(int groupId, {String? groupName}) => Uri(
    path: quizSession,
    queryParameters: {
      'groupId': '$groupId',
      if (groupName != null && groupName.isNotEmpty) 'groupName': groupName,
    },
  ).toString();
  static String quizReviewPath(int id) => '$quizReview/$id';
}
