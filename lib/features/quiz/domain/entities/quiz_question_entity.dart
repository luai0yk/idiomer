import 'package:equatable/equatable.dart';

class QuizOptionEntity extends Equatable {
  final int idiomId;
  final String englishText;
  final String englishMeaning;
  final String arabicText;
  final String arabicMeaning;

  const QuizOptionEntity({
    required this.idiomId,
    required this.englishText,
    required this.englishMeaning,
    required this.arabicText,
    required this.arabicMeaning,
  });

  @override
  List<Object?> get props => [
    idiomId,
    englishText,
    englishMeaning,
    arabicText,
    arabicMeaning,
  ];
}

class QuizQuestionEntity extends Equatable {
  final int idiomId;
  final String englishText;
  final String englishMeaning;
  final String arabicText;
  final List<QuizOptionEntity> options;
  final int correctIdiomId;

  const QuizQuestionEntity({
    required this.idiomId,
    required this.englishText,
    required this.englishMeaning,
    required this.arabicText,
    required this.options,
    required this.correctIdiomId,
  });

  @override
  List<Object?> get props => [
    idiomId,
    englishText,
    englishMeaning,
    arabicText,
    options,
    correctIdiomId,
  ];
}
