import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';

class WatchGroupIdiomsUseCase {
  final FlashcardsRepository _repository;

  const WatchGroupIdiomsUseCase(this._repository);

  Stream<List<IdiomEntity>> call(int groupId) =>
      _repository.watchGroupIdioms(groupId);
}
