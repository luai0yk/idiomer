import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class MoveIdiomToGroupUseCase {
  final FlashcardsRepository _repository;

  const MoveIdiomToGroupUseCase(this._repository);

  Future<void> call({
    required int idiomId,
    required int fromGroupId,
    required int toGroupId,
  }) => _repository.moveIdiomToGroup(
    idiomId: idiomId,
    fromGroupId: fromGroupId,
    toGroupId: toGroupId,
  );
}
