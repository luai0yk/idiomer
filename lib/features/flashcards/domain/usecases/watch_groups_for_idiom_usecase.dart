import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class WatchGroupsForIdiomUseCase {
  final FlashcardsRepository _repository;

  const WatchGroupsForIdiomUseCase(this._repository);

  Stream<List<FlashcardGroupEntity>> call(int idiomId) =>
      _repository.watchGroupsForIdiom(idiomId);
}
