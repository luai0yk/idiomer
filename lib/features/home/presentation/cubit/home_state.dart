import 'package:equatable/equatable.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final IdiomDetailEntity? idiomOfTheDay;
  final QuizStatsEntity quizStats;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.idiomOfTheDay,
    this.quizStats = const QuizStatsEntity(),
    this.errorMessage,
  });

  static const Object _unset = Object();

  HomeState copyWith({
    HomeStatus? status,
    Object? idiomOfTheDay = _unset,
    QuizStatsEntity? quizStats,
    Object? errorMessage = _unset,
  }) {
    return HomeState(
      status: status ?? this.status,
      idiomOfTheDay: idiomOfTheDay == _unset
          ? this.idiomOfTheDay
          : idiomOfTheDay as IdiomDetailEntity?,
      quizStats: quizStats ?? this.quizStats,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, idiomOfTheDay, quizStats, errorMessage];
}
