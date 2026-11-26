import 'package:idiomer/features/idioms/data/datasources/idioms_local_datasource.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';
import 'package:idiomer/features/idioms/domain/repositories/idioms_repository.dart';

class IdiomsRepositoryImpl implements IdiomsRepository {
  final IdiomsLocalDataSource _localDataSource;

  const IdiomsRepositoryImpl({required IdiomsLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Stream<List<CategoryEntity>> watchCategories() =>
      _localDataSource.watchCategories();

  @override
  Stream<List<IdiomEntity>> watchIdioms({
    String query = '',
    String? categoryId,
    int limit = 50,
    bool favoritesOnly = false,
  }) {
    return _localDataSource.watchIdioms(
      query: query,
      categoryId: categoryId,
      limit: limit,
      favoritesOnly: favoritesOnly,
    );
  }

  @override
  Stream<IdiomDetailEntity?> watchIdiomDetail(int idiomId) =>
      _localDataSource.watchIdiomDetail(idiomId);

  @override
  Stream<IdiomDetailEntity?> watchIdiomOfTheDay({DateTime? date}) =>
      _localDataSource.watchIdiomOfTheDay(date: date);

  @override
  Future<void> toggleFavorite(int idiomId) =>
      _localDataSource.toggleFavorite(idiomId);

  @override
  Future<void> setFavorite(int idiomId, {required bool isFavorite}) =>
      _localDataSource.setFavorite(idiomId, isFavorite: isFavorite);

  @override
  Future<void> clearAllFavorites() => _localDataSource.clearAllFavorites();
}
