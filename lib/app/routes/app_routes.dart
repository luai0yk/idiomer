class AppRoutes {
  AppRoutes._();

  static const String dbSetup = '/setup';
  static const String idioms = '/idioms';
  static const String favorites = '/favorites';
  static const String flashcards = '/flashcards';
  static const String settings = '/settings';
  static const String idiomDetail = '/idiom';

  static String idiomDetailPath(int id) => '$idiomDetail/$id';
}
