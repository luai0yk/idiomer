import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_assignment_result.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/flashcards/domain/usecases/add_idiom_to_default_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/create_flashcard_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/move_idiom_to_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/remove_idiom_from_group_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_flashcard_groups_usecase.dart';
import 'package:idiomer/features/flashcards/domain/usecases/watch_groups_for_idiom_usecase.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/usecases/toggle_favorite_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idiom_detail_usecase.dart';

import 'idiom_detail_state.dart';

class IdiomDetailCubit extends Cubit<IdiomDetailState> {
  final WatchIdiomDetailUseCase _watchIdiomDetail;
  final ToggleFavoriteUseCase _toggleFavorite;
  final WatchGroupsForIdiomUseCase _watchGroupsForIdiom;
  final WatchFlashcardGroupsUseCase _watchAllFlashcardGroups;
  final AddIdiomToDefaultGroupUseCase _addIdiomToDefaultGroup;
  final MoveIdiomToGroupUseCase _moveIdiomToGroup;
  final CreateFlashcardGroupUseCase _createFlashcardGroup;
  final RemoveIdiomFromGroupUseCase _removeIdiomFromGroup;

  StreamSubscription<IdiomDetailEntity?>? _subscription;
  StreamSubscription<List<FlashcardGroupEntity>>? _idiomGroupsSub;
  StreamSubscription<List<FlashcardGroupEntity>>? _allGroupsSub;
  int? _currentIdiomId;

  IdiomDetailCubit({
    required WatchIdiomDetailUseCase watchIdiomDetail,
    required ToggleFavoriteUseCase toggleFavorite,
    required WatchGroupsForIdiomUseCase watchGroupsForIdiom,
    required WatchFlashcardGroupsUseCase watchAllFlashcardGroups,
    required AddIdiomToDefaultGroupUseCase addIdiomToDefaultGroup,
    required MoveIdiomToGroupUseCase moveIdiomToGroup,
    required CreateFlashcardGroupUseCase createFlashcardGroup,
    required RemoveIdiomFromGroupUseCase removeIdiomFromGroup,
  }) : _watchIdiomDetail = watchIdiomDetail,
       _toggleFavorite = toggleFavorite,
       _watchGroupsForIdiom = watchGroupsForIdiom,
       _watchAllFlashcardGroups = watchAllFlashcardGroups,
       _addIdiomToDefaultGroup = addIdiomToDefaultGroup,
       _moveIdiomToGroup = moveIdiomToGroup,
       _createFlashcardGroup = createFlashcardGroup,
       _removeIdiomFromGroup = removeIdiomFromGroup,
       super(const IdiomDetailState());

  Future<void> watchIdiom(int idiomId) async {
    _currentIdiomId = idiomId;
    await _subscription?.cancel();
    await _idiomGroupsSub?.cancel();
    await _allGroupsSub?.cancel();
    if (isClosed) return;

    emit(const IdiomDetailState(status: IdiomDetailStatus.loading));

    _subscription = _watchIdiomDetail(idiomId).listen(
      (detail) {
        if (isClosed) return;
        if (detail == null) {
          emit(state.copyWith(status: IdiomDetailStatus.notFound, idiom: null));
        } else {
          emit(state.copyWith(status: IdiomDetailStatus.loaded, idiom: detail));
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: IdiomDetailStatus.error,
              errorMessage: error.toString(),
            ),
          );
        }
      },
    );

    _idiomGroupsSub = _watchGroupsForIdiom(idiomId).listen((groups) {
      if (!isClosed) {
        emit(state.copyWith(flashcardGroups: groups));
      }
    });

    _allGroupsSub = _watchAllFlashcardGroups().listen((groups) {
      if (!isClosed) {
        emit(state.copyWith(allFlashcardGroups: groups));
      }
    });
  }

  Future<void> toggleFavorite() async {
    final idiomId = _currentIdiomId;
    if (idiomId == null) return;
    await _toggleFavorite(idiomId);
  }

  Future<FlashcardAssignmentResult?> saveToDefaultFlashcardGroup({
    required String groupName,
    String? categoryId,
  }) async {
    final idiomId = _currentIdiomId;
    if (idiomId == null) return null;
    return _addIdiomToDefaultGroup(
      idiomId: idiomId,
      groupName: groupName,
      categoryId: categoryId,
    );
  }

  Future<void> moveToFlashcardGroup({
    required int fromGroupId,
    required int toGroupId,
  }) async {
    final idiomId = _currentIdiomId;
    if (idiomId == null) return;
    await _moveIdiomToGroup(
      idiomId: idiomId,
      fromGroupId: fromGroupId,
      toGroupId: toGroupId,
    );
  }

  Future<FlashcardGroupEntity?> createAndMoveToFlashcardGroup({
    required int fromGroupId,
    required String newGroupName,
  }) async {
    final idiomId = _currentIdiomId;
    if (idiomId == null) return null;
    final created = await _createFlashcardGroup(name: newGroupName);
    await _moveIdiomToGroup(
      idiomId: idiomId,
      fromGroupId: fromGroupId,
      toGroupId: created.id,
    );
    return created;
  }

  Future<void> removeFromFlashcardGroup(int groupId) async {
    final idiomId = _currentIdiomId;
    if (idiomId == null) return;
    await _removeIdiomFromGroup(groupId: groupId, idiomId: idiomId);
  }

  void retry() {
    final idiomId = _currentIdiomId;
    if (idiomId != null) {
      watchIdiom(idiomId);
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _idiomGroupsSub?.cancel();
    await _allGroupsSub?.cancel();
    return super.close();
  }
}
