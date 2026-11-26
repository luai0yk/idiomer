import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';

class GetGroupStudyCardsUseCase {
  final FlashcardsRepository _repository;

  const GetGroupStudyCardsUseCase(this._repository);

  Future<List<IdiomDetailEntity>> call(int groupId) =>
      _repository.getGroupStudyCards(groupId);
}
