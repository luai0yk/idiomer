import 'package:idiomer/features/flashcards/data/datasources/flashcards_local_datasource.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_assignment_result.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';

class FlashcardsRepositoryImpl implements FlashcardsRepository {
  final FlashcardsLocalDataSource _localDataSource;

  const FlashcardsRepositoryImpl({
    required FlashcardsLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Stream<List<FlashcardGroupEntity>> watchGroups() =>
      _localDataSource.watchGroups();

  @override
  Stream<FlashcardGroupEntity?> watchGroup(int groupId) =>
      _localDataSource.watchGroup(groupId);

  @override
  Stream<List<IdiomEntity>> watchGroupIdioms(int groupId) =>
      _localDataSource.watchGroupIdioms(groupId);

  @override
  Future<List<IdiomDetailEntity>> getGroupStudyCards(int groupId) =>
      _localDataSource.getGroupStudyCards(groupId);

  @override
  Stream<List<FlashcardGroupEntity>> watchGroupsForIdiom(int idiomId) =>
      _localDataSource.watchGroupsForIdiom(idiomId);

  @override
  Future<FlashcardGroupEntity> createGroup({
    required String name,
    String? categoryId,
  }) => _localDataSource.createGroup(name: name, categoryId: categoryId);

  @override
  Future<void> renameGroup({required int groupId, required String newName}) =>
      _localDataSource.renameGroup(groupId: groupId, newName: newName);

  @override
  Future<void> deleteGroup(int groupId) =>
      _localDataSource.deleteGroup(groupId);

  @override
  Future<void> clearAllGroups() => _localDataSource.clearAllGroups();

  @override
  Future<bool> addIdiomToGroup({required int groupId, required int idiomId}) =>
      _localDataSource.addIdiomToGroup(groupId: groupId, idiomId: idiomId);

  @override
  Future<FlashcardAssignmentResult> addIdiomToDefaultCategoryGroup({
    required int idiomId,
    required String groupName,
    String? categoryId,
  }) => _localDataSource.addIdiomToDefaultCategoryGroup(
    idiomId: idiomId,
    groupName: groupName,
    categoryId: categoryId,
  );

  @override
  Future<void> moveIdiomToGroup({
    required int idiomId,
    required int fromGroupId,
    required int toGroupId,
  }) => _localDataSource.moveIdiomToGroup(
    idiomId: idiomId,
    fromGroupId: fromGroupId,
    toGroupId: toGroupId,
  );

  @override
  Future<void> removeIdiomFromGroup({
    required int groupId,
    required int idiomId,
  }) =>
      _localDataSource.removeIdiomFromGroup(groupId: groupId, idiomId: idiomId);
}
