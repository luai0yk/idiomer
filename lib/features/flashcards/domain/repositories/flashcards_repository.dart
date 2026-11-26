import 'package:idiomer/features/flashcards/domain/entities/flashcard_assignment_result.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';

abstract class FlashcardsRepository {
  Stream<List<FlashcardGroupEntity>> watchGroups();

  Stream<FlashcardGroupEntity?> watchGroup(int groupId);

  Stream<List<IdiomEntity>> watchGroupIdioms(int groupId);

  Future<List<IdiomDetailEntity>> getGroupStudyCards(int groupId);

  Stream<List<FlashcardGroupEntity>> watchGroupsForIdiom(int idiomId);

  Future<FlashcardGroupEntity> createGroup({
    required String name,
    String? categoryId,
  });

  Future<void> renameGroup({required int groupId, required String newName});

  Future<void> deleteGroup(int groupId);

  Future<void> clearAllGroups();

  Future<bool> addIdiomToGroup({required int groupId, required int idiomId});

  Future<FlashcardAssignmentResult> addIdiomToDefaultCategoryGroup({
    required int idiomId,
    required String groupName,
    String? categoryId,
  });

  Future<void> moveIdiomToGroup({
    required int idiomId,
    required int fromGroupId,
    required int toGroupId,
  });

  Future<void> removeIdiomFromGroup({
    required int groupId,
    required int idiomId,
  });
}
