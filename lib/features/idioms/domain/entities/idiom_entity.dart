import 'package:equatable/equatable.dart';

class IdiomEntity extends Equatable {
  final int id;
  final String? slug;
  final String englishText;
  final String arabicText;
  final String? englishExample;
  final String? arabicExample;
  final bool isFavorite;

  const IdiomEntity({
    required this.id,
    this.slug,
    required this.englishText,
    required this.arabicText,
    this.englishExample,
    this.arabicExample,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
    id,
    slug,
    englishText,
    arabicText,
    englishExample,
    arabicExample,
    isFavorite,
  ];
}
