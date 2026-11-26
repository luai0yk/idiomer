import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class CreateFlashcardGroupUseCase {
  final FlashcardsRepository _repository;

  const CreateFlashcardGroupUseCase(this._repository);

  Future<FlashcardGroupEntity> call({
    required String name,
    String? categoryId,
  }) => _repository.createGroup(name: name, categoryId: categoryId);
}
