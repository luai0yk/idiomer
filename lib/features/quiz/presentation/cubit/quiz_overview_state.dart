import 'package:equatable/equatable.dart';
import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';

enum QuizOverviewStatus { initial, loading, loaded, error }

class QuizOverviewState extends Equatable {
  final QuizOverviewStatus status;
  final QuizStatsEntity stats;
  final String? errorMessage;

  const QuizOverviewState({
    this.status = QuizOverviewStatus.initial,
    this.stats = const QuizStatsEntity(),
    this.errorMessage,
  });

  static const Object _unset = Object();

  QuizOverviewState copyWith({
    QuizOverviewStatus? status,
    QuizStatsEntity? stats,
    Object? errorMessage = _unset,
  }) {
    return QuizOverviewState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, stats, errorMessage];
}
