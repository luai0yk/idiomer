import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class ClearAllFlashcardGroupsUseCase {
  final FlashcardsRepository _repository;

  const ClearAllFlashcardGroupsUseCase(this._repository);

  Future<void> call() => _repository.clearAllGroups();
}
