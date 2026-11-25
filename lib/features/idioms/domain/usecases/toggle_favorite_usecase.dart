import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';

class ToggleFavoriteUseCase {
  final IdiomsRepository _repository;

  const ToggleFavoriteUseCase(this._repository);

  Future<void> call(int idiomId) => _repository.toggleFavorite(idiomId);
}
