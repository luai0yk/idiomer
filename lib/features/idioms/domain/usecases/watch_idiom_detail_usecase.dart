import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';

class WatchIdiomDetailUseCase {
  final IdiomsRepository _repository;

  const WatchIdiomDetailUseCase(this._repository);

  Stream<IdiomDetailEntity?> call(int idiomId) =>
      _repository.watchIdiomDetail(idiomId);
}
