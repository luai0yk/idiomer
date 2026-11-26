import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class WatchFlashcardGroupsUseCase {
  final FlashcardsRepository _repository;

  const WatchFlashcardGroupsUseCase(this._repository);

  Stream<List<FlashcardGroupEntity>> call() => _repository.watchGroups();
}
