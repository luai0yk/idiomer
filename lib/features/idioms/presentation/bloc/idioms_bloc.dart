import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';
import 'package:idiomer/features/idioms/domain/usecases/toggle_favorite_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_categories_usecase.dart';
import 'package:idiomer/features/idioms/domain/usecases/watch_idioms_usecase.dart';
import 'package:stream_transform/stream_transform.dart';

import 'idioms_event.dart';
import 'idioms_state.dart';

EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class IdiomsBloc extends Bloc<IdiomsEvent, IdiomsState> {
  static const int pageSize = 50;

  final WatchIdiomsUseCase _watchIdioms;
  final WatchCategoriesUseCase _watchCategories;
  final ToggleFavoriteUseCase _toggleFavorite;
  final bool _favoritesOnly;

  StreamSubscription<List<CategoryEntity>>? _categoriesSub;
  StreamSubscription<List<IdiomEntity>>? _idiomsSub;
  int _currentLimit = pageSize;

  IdiomsBloc({
    required WatchIdiomsUseCase watchIdioms,
    required WatchCategoriesUseCase watchCategories,
    required ToggleFavoriteUseCase toggleFavorite,
    bool favoritesOnly = false,
  }) : _watchIdioms = watchIdioms,
       _watchCategories = watchCategories,
       _toggleFavorite = toggleFavorite,
       _favoritesOnly = favoritesOnly,
       super(const IdiomsState()) {
    on<IdiomsStarted>(_onStarted);
    on<IdiomsSearchChanged>(
      _onSearchChanged,
      transformer: _debounce(const Duration(milliseconds: 250)),
    );
    on<IdiomsCategorySelected>(_onCategorySelected);
    on<IdiomsCategoryExpandToggled>(_onCategoryExpandToggled);
    on<IdiomsLoadMoreRequested>(_onLoadMoreRequested);
    on<IdiomsFavoriteToggled>(_onFavoriteToggled);
    on<IdiomsRetryRequested>(_onRetryRequested);
    on<IdiomsFiltersCleared>(_onFiltersCleared);
    on<IdiomsCategoriesUpdated>(_onCategoriesUpdated);
    on<IdiomsListUpdated>(_onListUpdated);
    on<IdiomsStreamFailed>(_onStreamFailed);
  }

  Future<void> _onStarted(
    IdiomsStarted event,
    Emitter<IdiomsState> emit,
  ) async {
    emit(state.copyWith(status: IdiomsStatus.loading, errorMessage: null));
    _subscribeCategories();
    await _subscribeIdioms();
  }

  Future<void> _onSearchChanged(
    IdiomsSearchChanged event,
    Emitter<IdiomsState> emit,
  ) async {
    if (event.query == state.query) return;
    _currentLimit = pageSize;
    emit(
      state.copyWith(
        query: event.query,
        isLoadingMore: false,
        errorMessage: null,
      ),
    );
    await _subscribeIdioms();
  }

  Future<void> _onCategorySelected(
    IdiomsCategorySelected event,
    Emitter<IdiomsState> emit,
  ) async {
    final nextCategory = state.selectedCategoryId == event.categoryId
        ? null
        : event.categoryId;
    if (nextCategory == state.selectedCategoryId && event.categoryId != null) {
      return;
    }
    _currentLimit = pageSize;
    emit(
      state.copyWith(
        selectedCategoryId: nextCategory,
        isLoadingMore: false,
        errorMessage: null,
      ),
    );
    await _subscribeIdioms();
  }

  void _onCategoryExpandToggled(
    IdiomsCategoryExpandToggled event,
    Emitter<IdiomsState> emit,
  ) {
    emit(state.copyWith(isCategoriesExpanded: !state.isCategoriesExpanded));
  }

  Future<void> _onLoadMoreRequested(
    IdiomsLoadMoreRequested event,
    Emitter<IdiomsState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;
    _currentLimit += pageSize;
    emit(state.copyWith(isLoadingMore: true));
    await _subscribeIdioms();
  }

  Future<void> _onFavoriteToggled(
    IdiomsFavoriteToggled event,
    Emitter<IdiomsState> emit,
  ) async {
    try {
      await _toggleFavorite(event.idiomId);
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    }
  }

  Future<void> _onRetryRequested(
    IdiomsRetryRequested event,
    Emitter<IdiomsState> emit,
  ) async {
    emit(state.copyWith(status: IdiomsStatus.loading, errorMessage: null));
    _subscribeCategories();
    await _subscribeIdioms();
  }

  Future<void> _onFiltersCleared(
    IdiomsFiltersCleared event,
    Emitter<IdiomsState> emit,
  ) async {
    _currentLimit = pageSize;
    emit(
      state.copyWith(
        query: '',
        selectedCategoryId: null,
        isLoadingMore: false,
        errorMessage: null,
      ),
    );
    await _subscribeIdioms();
  }

  void _onCategoriesUpdated(
    IdiomsCategoriesUpdated event,
    Emitter<IdiomsState> emit,
  ) {
    emit(state.copyWith(categories: event.categories));
  }

  void _onListUpdated(IdiomsListUpdated event, Emitter<IdiomsState> emit) {
    final hasMore = event.idioms.length > _currentLimit;
    final visibleIdioms = hasMore
        ? event.idioms.take(_currentLimit).toList()
        : event.idioms;

    emit(
      state.copyWith(
        status: IdiomsStatus.loaded,
        idioms: visibleIdioms,
        hasMore: hasMore,
        isLoadingMore: false,
        errorMessage: null,
      ),
    );
  }

  void _onStreamFailed(IdiomsStreamFailed event, Emitter<IdiomsState> emit) {
    emit(
      state.copyWith(
        status: IdiomsStatus.error,
        isLoadingMore: false,
        errorMessage: event.message,
      ),
    );
  }

  void _subscribeCategories() {
    _categoriesSub?.cancel();
    _categoriesSub = _watchCategories().listen(
      (categories) {
        if (!isClosed) add(IdiomsCategoriesUpdated(categories));
      },
      onError: (Object error) {
        if (!isClosed) add(IdiomsStreamFailed(error.toString()));
      },
    );
  }

  Future<void> _subscribeIdioms() async {
    await _idiomsSub?.cancel();
    if (isClosed) return;

    // Fetch one extra item to determine whether more pages are available.
    _idiomsSub =
        _watchIdioms(
          query: state.query,
          categoryId: state.selectedCategoryId,
          limit: _currentLimit + 1,
          favoritesOnly: _favoritesOnly,
        ).listen(
          (idioms) {
            if (!isClosed) add(IdiomsListUpdated(idioms));
          },
          onError: (Object error) {
            if (!isClosed) add(IdiomsStreamFailed(error.toString()));
          },
        );
  }

  @override
  Future<void> close() async {
    await _categoriesSub?.cancel();
    await _idiomsSub?.cancel();
    return super.close();
  }
}
