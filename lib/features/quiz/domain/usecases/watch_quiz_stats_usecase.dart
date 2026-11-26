import 'package:idiomer/features/quiz/domain/entities/quiz_stats_entity.dart';
import 'package:idiomer/features/quiz/domain/repositories/quiz_repository.dart';

class WatchQuizStatsUseCase {
  final QuizRepository _repository;

  const WatchQuizStatsUseCase(this._repository);

  Stream<QuizStatsEntity> call() => _repository.watchQuizStats();
}
