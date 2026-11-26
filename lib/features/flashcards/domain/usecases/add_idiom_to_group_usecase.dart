import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class AddIdiomToGroupUseCase {
  final FlashcardsRepository _repository;

  const AddIdiomToGroupUseCase(this._repository);

  Future<bool> call({required int groupId, required int idiomId}) =>
      _repository.addIdiomToGroup(groupId: groupId, idiomId: idiomId);
}
