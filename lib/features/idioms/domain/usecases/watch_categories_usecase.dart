import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';

class WatchCategoriesUseCase {
  final IdiomsRepository _repository;

  const WatchCategoriesUseCase(this._repository);

  Stream<List<CategoryEntity>> call() => _repository.watchCategories();
}
