import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class RemoveIdiomFromGroupUseCase {
  final FlashcardsRepository _repository;

  const RemoveIdiomFromGroupUseCase(this._repository);

  Future<void> call({required int groupId, required int idiomId}) =>
      _repository.removeIdiomFromGroup(groupId: groupId, idiomId: idiomId);
}
