import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class WatchFlashcardGroupUseCase {
  final FlashcardsRepository _repository;

  const WatchFlashcardGroupUseCase(this._repository);

  Stream<FlashcardGroupEntity?> call(int groupId) =>
      _repository.watchGroup(groupId);
}
