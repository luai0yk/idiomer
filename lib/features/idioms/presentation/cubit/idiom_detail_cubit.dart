import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';
import 'package:idiomer/features/idioms/domain/usecases/toggle_favorite_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idiom_detail_usecase.dart';

import 'idiom_detail_state.dart';

class IdiomDetailCubit extends Cubit<IdiomDetailState> {
  final WatchIdiomDetailUseCase _watchIdiomDetail;
  final ToggleFavoriteUseCase _toggleFavorite;
  StreamSubscription<IdiomDetailEntity?>? _subscription;
  int? _currentIdiomId;

  IdiomDetailCubit({
    required WatchIdiomDetailUseCase watchIdiomDetail,
    required ToggleFavoriteUseCase toggleFavorite,
  }) : _watchIdiomDetail = watchIdiomDetail,
       _toggleFavorite = toggleFavorite,
       super(const IdiomDetailState());

  Future<void> watchIdiom(int idiomId) async {
    _currentIdiomId = idiomId;
    await _subscription?.cancel();
    if (isClosed) return;

    emit(const IdiomDetailState(status: IdiomDetailStatus.loading));

    _subscription = _watchIdiomDetail(idiomId).listen(
      (detail) {
        if (isClosed) return;
        if (detail == null) {
          emit(const IdiomDetailState(status: IdiomDetailStatus.notFound));
        } else {
          emit(
            IdiomDetailState(status: IdiomDetailStatus.loaded, idiom: detail),
          );
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(
            IdiomDetailState(
              status: IdiomDetailStatus.error,
              errorMessage: error.toString(),
            ),
          );
        }
      },
    );
  }

  Future<void> toggleFavorite() async {
    final idiomId = _currentIdiomId;
    if (idiomId == null) return;
    await _toggleFavorite(idiomId);
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
    return super.close();
  }
}
