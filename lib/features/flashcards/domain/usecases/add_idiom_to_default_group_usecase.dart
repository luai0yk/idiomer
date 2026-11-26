import 'package:idiomer/features/flashcards/domain/entities/flashcard_assignment_result.dart';
import 'package:idiomer/features/flashcards/domain/repositories/flashcards_repository.dart';

class AddIdiomToDefaultGroupUseCase {
  final FlashcardsRepository _repository;

  const AddIdiomToDefaultGroupUseCase(this._repository);

  Future<FlashcardAssignmentResult> call({
    required int idiomId,
    required String groupName,
    String? categoryId,
  }) => _repository.addIdiomToDefaultCategoryGroup(
    idiomId: idiomId,
    groupName: groupName,
    categoryId: categoryId,
  );
}
