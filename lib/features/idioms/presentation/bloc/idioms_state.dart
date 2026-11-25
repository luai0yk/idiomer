import 'package:equatable/equatable.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';

enum IdiomsStatus { initial, loading, loaded, error }

class IdiomsState extends Equatable {
  final IdiomsStatus status;
  final List<IdiomEntity> idioms;
  final List<CategoryEntity> categories;
  final String query;
  final String? selectedCategoryId;
  final bool isCategoriesExpanded;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const IdiomsState({
    this.status = IdiomsStatus.initial,
    this.idioms = const [],
    this.categories = const [],
    this.query = '',
    this.selectedCategoryId,
    this.isCategoriesExpanded = false,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasActiveFilters =>
      query.trim().isNotEmpty || selectedCategoryId != null;

  static const Object _unset = Object();

  IdiomsState copyWith({
    IdiomsStatus? status,
    List<IdiomEntity>? idioms,
    List<CategoryEntity>? categories,
    String? query,
    Object? selectedCategoryId = _unset,
    bool? isCategoriesExpanded,
    bool? hasMore,
    bool? isLoadingMore,
    Object? errorMessage = _unset,
  }) {
    return IdiomsState(
      status: status ?? this.status,
      idioms: idioms ?? this.idioms,
      categories: categories ?? this.categories,
      query: query ?? this.query,
      selectedCategoryId: selectedCategoryId == _unset
          ? this.selectedCategoryId
          : selectedCategoryId as String?,
      isCategoriesExpanded: isCategoriesExpanded ?? this.isCategoriesExpanded,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    idioms,
    categories,
    query,
    selectedCategoryId,
    isCategoriesExpanded,
    hasMore,
    isLoadingMore,
    errorMessage,
  ];
}
