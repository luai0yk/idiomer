import 'package:equatable/equatable.dart';

class FlashcardGroupEntity extends Equatable {
  final int id;
  final String name;
  final String? categoryId;
  final int idiomCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FlashcardGroupEntity({
    required this.id,
    required this.name,
    this.categoryId,
    required this.idiomCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    categoryId,
    idiomCount,
    createdAt,
    updatedAt,
  ];
}
