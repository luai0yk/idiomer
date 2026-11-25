import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final int displayOrder;
  final String englishName;
  final String arabicName;
  final String? englishDescription;
  final String? arabicDescription;

  const CategoryEntity({
    required this.id,
    required this.displayOrder,
    required this.englishName,
    required this.arabicName,
    this.englishDescription,
    this.arabicDescription,
  });

  String localizedName({required bool isArabic}) =>
      isArabic ? arabicName : englishName;

  @override
  List<Object?> get props => [
    id,
    displayOrder,
    englishName,
    arabicName,
    englishDescription,
    arabicDescription,
  ];
}
