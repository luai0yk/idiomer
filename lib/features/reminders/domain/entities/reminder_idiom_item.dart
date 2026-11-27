import 'package:equatable/equatable.dart';

class ReminderIdiomItem extends Equatable {
  final int id;
  final String englishText;
  final String arabicText;
  final String englishMeaning;
  final String arabicMeaning;
  final String? englishExample;

  const ReminderIdiomItem({
    required this.id,
    required this.englishText,
    required this.arabicText,
    required this.englishMeaning,
    required this.arabicMeaning,
    this.englishExample,
  });

  @override
  List<Object?> get props => [
    id,
    englishText,
    arabicText,
    englishMeaning,
    arabicMeaning,
    englishExample,
  ];
}
