import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';

class WatchIdiomOfTheDayUseCase {
  final IdiomsRepository _repository;

  const WatchIdiomOfTheDayUseCase(this._repository);

  Stream<IdiomDetailEntity?> call({DateTime? date}) =>
      _repository.watchIdiomOfTheDay(date: date);
}
