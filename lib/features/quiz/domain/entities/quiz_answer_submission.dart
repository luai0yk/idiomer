import 'package:equatable/equatable.dart';

class QuizAnswerSubmission extends Equatable {
  final int idiomId;
  final int? selectedIdiomId;
  final int correctIdiomId;
  final List<int> optionIdiomIds;

  const QuizAnswerSubmission({
    required this.idiomId,
    required this.selectedIdiomId,
    required this.correctIdiomId,
    required this.optionIdiomIds,
  });

  @override
  List<Object?> get props => [
    idiomId,
    selectedIdiomId,
    correctIdiomId,
    optionIdiomIds,
  ];
}
