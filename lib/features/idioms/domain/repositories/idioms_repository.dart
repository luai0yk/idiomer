import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';

abstract class IdiomsRepository {
  Stream<List<CategoryEntity>> watchCategories();

  Stream<List<IdiomEntity>> watchIdioms({
    String query = '',
    String? categoryId,
    int limit = 50,
    bool favoritesOnly = false,
  });

  Stream<IdiomDetailEntity?> watchIdiomDetail(int idiomId);

  Future<void> toggleFavorite(int idiomId);

  Future<void> setFavorite(int idiomId, {required bool isFavorite});

  Future<void> clearAllFavorites();
}
