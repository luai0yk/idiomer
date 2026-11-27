import 'package:equatable/equatable.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final IdiomDetailEntity? idiomOfTheDay;
  final QuizStatsEntity quizStats;
  final List<FlashcardGroupEntity> flashcardGroups;
  final List<CategoryEntity> categories;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.idiomOfTheDay,
    this.quizStats = const QuizStatsEntity(),
    this.flashcardGroups = const [],
    this.categories = const [],
    this.errorMessage,
  });

  List<FlashcardGroupEntity> get studyableFlashcardGroups =>
      flashcardGroups.where((g) => g.idiomCount > 0).toList();

  static const Object _unset = Object();

  HomeState copyWith({
    HomeStatus? status,
    Object? idiomOfTheDay = _unset,
    QuizStatsEntity? quizStats,
    List<FlashcardGroupEntity>? flashcardGroups,
    List<CategoryEntity>? categories,
    Object? errorMessage = _unset,
  }) {
    return HomeState(
      status: status ?? this.status,
      idiomOfTheDay: idiomOfTheDay == _unset
          ? this.idiomOfTheDay
          : idiomOfTheDay as IdiomDetailEntity?,
      quizStats: quizStats ?? this.quizStats,
      flashcardGroups: flashcardGroups ?? this.flashcardGroups,
      categories: categories ?? this.categories,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    idiomOfTheDay,
    quizStats,
    flashcardGroups,
    categories,
    errorMessage,
  ];
}
