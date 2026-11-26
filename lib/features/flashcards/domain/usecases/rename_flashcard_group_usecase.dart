import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class RenameFlashcardGroupUseCase {
  final FlashcardsRepository _repository;

  const RenameFlashcardGroupUseCase(this._repository);

  Future<void> call({required int groupId, required String newName}) =>
      _repository.renameGroup(groupId: groupId, newName: newName);
}
