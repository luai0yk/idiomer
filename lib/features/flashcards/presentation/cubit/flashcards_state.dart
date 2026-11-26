import 'package:equatable/equatable.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';

enum FlashcardsStatus { initial, loading, loaded, error }

class FlashcardsState extends Equatable {
  final FlashcardsStatus status;
  final List<FlashcardGroupEntity> groups;
  final String? errorMessage;

  const FlashcardsState({
    this.status = FlashcardsStatus.initial,
    this.groups = const [],
    this.errorMessage,
  });

  static const Object _unset = Object();

  FlashcardsState copyWith({
    FlashcardsStatus? status,
    List<FlashcardGroupEntity>? groups,
    Object? errorMessage = _unset,
  }) {
    return FlashcardsState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, groups, errorMessage];
}
