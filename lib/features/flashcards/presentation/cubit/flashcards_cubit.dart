import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/usecases/clear_all_flashcard_groups_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/create_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/delete_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/rename_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_groups_usecase.dart';

import 'flashcards_state.dart';

class FlashcardsCubit extends Cubit<FlashcardsState> {
  final WatchFlashcardGroupsUseCase _watchGroups;
  final CreateFlashcardGroupUseCase _createGroup;
  final RenameFlashcardGroupUseCase _renameGroup;
  final DeleteFlashcardGroupUseCase _deleteGroup;
  final ClearAllFlashcardGroupsUseCase _clearAllGroups;

  StreamSubscription<List<FlashcardGroupEntity>>? _subscription;

  FlashcardsCubit({
    required WatchFlashcardGroupsUseCase watchGroups,
    required CreateFlashcardGroupUseCase createGroup,
    required RenameFlashcardGroupUseCase renameGroup,
    required DeleteFlashcardGroupUseCase deleteGroup,
    required ClearAllFlashcardGroupsUseCase clearAllGroups,
  }) : _watchGroups = watchGroups,
       _createGroup = createGroup,
       _renameGroup = renameGroup,
       _deleteGroup = deleteGroup,
       _clearAllGroups = clearAllGroups,
       super(const FlashcardsState());

  Future<void> watchAll() async {
    await _subscription?.cancel();
    if (isClosed) return;

    emit(state.copyWith(status: FlashcardsStatus.loading, errorMessage: null));

    _subscription = _watchGroups().listen(
      (groups) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: FlashcardsStatus.loaded,
              groups: groups,
              errorMessage: null,
            ),
          );
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: FlashcardsStatus.error,
              errorMessage: error.toString(),
            ),
          );
        }
      },
    );
  }

  Future<FlashcardGroupEntity> createGroup(String name) {
    return _createGroup(name: name);
  }

  Future<void> renameGroup(int groupId, String newName) {
    return _renameGroup(groupId: groupId, newName: newName);
  }

  Future<void> deleteGroup(int groupId) {
    return _deleteGroup(groupId);
  }

  Future<void> clearAllGroups() {
    return _clearAllGroups();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
