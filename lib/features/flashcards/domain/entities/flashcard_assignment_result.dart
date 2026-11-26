import 'package:equatable/equatable.dart';
import 'package:idiomer/features/flashcards/domain/entities/flashcard_group_entity.dart';

class FlashcardAssignmentResult extends Equatable {
  final FlashcardGroupEntity group;
  final bool wasAdded;

  const FlashcardAssignmentResult({
    required this.group,
    required this.wasAdded,
  });

  @override
  List<Object?> get props => [group, wasAdded];
}
