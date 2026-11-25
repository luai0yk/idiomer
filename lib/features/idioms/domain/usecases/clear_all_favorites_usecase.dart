import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';

class ClearAllFavoritesUseCase {
  final IdiomsRepository _repository;

  const ClearAllFavoritesUseCase(this._repository);

  Future<void> call() => _repository.clearAllFavorites();
}
