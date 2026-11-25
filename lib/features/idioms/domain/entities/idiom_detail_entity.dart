import 'package:equatable/equatable.dart';
import 'package:idiomer/features/idioms/domain/entities/category_entity.dart';

class IdiomDefinitionEntity extends Equatable {
  final int id;
  final int displayOrder;
  final String englishMeaning;
  final String arabicMeaning;

  const IdiomDefinitionEntity({
    required this.id,
    required this.displayOrder,
    required this.englishMeaning,
    required this.arabicMeaning,
  });

  @override
  List<Object?> get props => [id, displayOrder, englishMeaning, arabicMeaning];
}

class IdiomExampleEntity extends Equatable {
  final int id;
  final int? definitionId;
  final int displayOrder;
  final String englishSentence;
  final String arabicSentence;

  const IdiomExampleEntity({
    required this.id,
    this.definitionId,
    required this.displayOrder,
    required this.englishSentence,
    required this.arabicSentence,
  });

  @override
  List<Object?> get props => [
    id,
    definitionId,
    displayOrder,
    englishSentence,
    arabicSentence,
  ];
}

class IdiomDetailEntity extends Equatable {
  final int id;
  final String? slug;
  final String englishText;
  final String arabicText;
  final String? englishNotes;
  final String? arabicNotes;
  final List<IdiomDefinitionEntity> definitions;
  final List<IdiomExampleEntity> examples;
  final List<CategoryEntity> categories;
  final bool isFavorite;

  const IdiomDetailEntity({
    required this.id,
    this.slug,
    required this.englishText,
    required this.arabicText,
    this.englishNotes,
    this.arabicNotes,
    required this.definitions,
    required this.examples,
    required this.categories,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [
    id,
    slug,
    englishText,
    arabicText,
    englishNotes,
    arabicNotes,
    definitions,
    examples,
    categories,
    isFavorite,
  ];
}
