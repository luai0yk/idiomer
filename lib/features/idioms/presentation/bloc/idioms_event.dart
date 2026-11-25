import 'package:equatable/equatable.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_entity.dart';

abstract class IdiomsEvent extends Equatable {
  const IdiomsEvent();

  @override
  List<Object?> get props => [];
}

final class IdiomsStarted extends IdiomsEvent {
  const IdiomsStarted();
}

final class IdiomsSearchChanged extends IdiomsEvent {
  final String query;

  const IdiomsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

final class IdiomsCategorySelected extends IdiomsEvent {
  final String? categoryId;

  const IdiomsCategorySelected(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

final class IdiomsCategoryExpandToggled extends IdiomsEvent {
  const IdiomsCategoryExpandToggled();
}

final class IdiomsLoadMoreRequested extends IdiomsEvent {
  const IdiomsLoadMoreRequested();
}

final class IdiomsFavoriteToggled extends IdiomsEvent {
  final int idiomId;

  const IdiomsFavoriteToggled(this.idiomId);

  @override
  List<Object?> get props => [idiomId];
}

final class IdiomsRetryRequested extends IdiomsEvent {
  const IdiomsRetryRequested();
}

final class IdiomsFiltersCleared extends IdiomsEvent {
  const IdiomsFiltersCleared();
}

final class IdiomsCategoriesUpdated extends IdiomsEvent {
  final List<CategoryEntity> categories;

  const IdiomsCategoriesUpdated(this.categories);

  @override
  List<Object?> get props => [categories];
}

final class IdiomsListUpdated extends IdiomsEvent {
  final List<IdiomEntity> idioms;

  const IdiomsListUpdated(this.idioms);

  @override
  List<Object?> get props => [idioms];
}

final class IdiomsStreamFailed extends IdiomsEvent {
  final String message;

  const IdiomsStreamFailed(this.message);

  @override
  List<Object?> get props => [message];
}
