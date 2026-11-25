import 'package:equatable/equatable.dart';
import 'package:idiomer/features/idioms/domain/entities/idiom_detail_entity.dart';

enum IdiomDetailStatus { initial, loading, loaded, notFound, error }

class IdiomDetailState extends Equatable {
  final IdiomDetailStatus status;
  final IdiomDetailEntity? idiom;
  final String? errorMessage;

  const IdiomDetailState({
    this.status = IdiomDetailStatus.initial,
    this.idiom,
    this.errorMessage,
  });

  IdiomDetailState copyWith({
    IdiomDetailStatus? status,
    IdiomDetailEntity? idiom,
    String? errorMessage,
  }) {
    return IdiomDetailState(
      status: status ?? this.status,
      idiom: idiom ?? this.idiom,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, idiom, errorMessage];
}
