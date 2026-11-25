import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';
import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';

class WatchIdiomsUseCase {
  final IdiomsRepository _repository;

  const WatchIdiomsUseCase(this._repository);

  Stream<List<IdiomEntity>> call({
    String query = '',
    String? categoryId,
    int limit = 50,
    bool favoritesOnly = false,
  }) {
    return _repository.watchIdioms(
      query: query,
      categoryId: categoryId,
      limit: limit,
      favoritesOnly: favoritesOnly,
    );
  }
}
