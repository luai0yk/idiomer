import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class DeleteFlashcardGroupUseCase {
  final FlashcardsRepository _repository;

  const DeleteFlashcardGroupUseCase(this._repository);

  Future<void> call(int groupId) => _repository.deleteGroup(groupId);
}
