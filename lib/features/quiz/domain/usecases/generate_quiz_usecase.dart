import 'package:idiomer/features/quiz/domain/entities/quiz_question_entity.dart';
import 'package:idiomer/features/quiz/domain/repositories/quiz_repository.dart';

class GenerateQuizUseCase {
  final QuizRepository _repository;

  const GenerateQuizUseCase(this._repository);

  Future<List<QuizQuestionEntity>> call({
    int questionCount = 8,
    int? flashcardGroupId,
  }) => _repository.generateQuiz(
    questionCount: questionCount,
    flashcardGroupId: flashcardGroupId,
  );
}
