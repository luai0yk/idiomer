import 'package:equatable/equatable.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';

enum IdiomDetailStatus { initial, loading, loaded, notFound, error }

class IdiomDetailState extends Equatable {
  final IdiomDetailStatus status;
  final IdiomDetailEntity? idiom;
  final List<FlashcardGroupEntity> flashcardGroups;
  final List<FlashcardGroupEntity> allFlashcardGroups;
  final String? errorMessage;

  const IdiomDetailState({
    this.status = IdiomDetailStatus.initial,
    this.idiom,
    this.flashcardGroups = const [],
    this.allFlashcardGroups = const [],
    this.errorMessage,
  });

  bool get isInFlashcards => flashcardGroups.isNotEmpty;

  IdiomDetailState copyWith({
    IdiomDetailStatus? status,
    IdiomDetailEntity? idiom,
    List<FlashcardGroupEntity>? flashcardGroups,
    List<FlashcardGroupEntity>? allFlashcardGroups,
    String? errorMessage,
  }) {
    return IdiomDetailState(
      status: status ?? this.status,
      idiom: idiom ?? this.idiom,
      flashcardGroups: flashcardGroups ?? this.flashcardGroups,
      allFlashcardGroups: allFlashcardGroups ?? this.allFlashcardGroups,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    idiom,
    flashcardGroups,
    allFlashcardGroups,
    errorMessage,
  ];
}
