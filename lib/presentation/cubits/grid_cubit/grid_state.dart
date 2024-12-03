part of 'grid_cubit.dart';

abstract class GridState extends Equatable {
  final GridEntity? grid;
  final List<List<int>>? wordCoordinates;

  const GridState({this.grid, this.wordCoordinates});

  @override
  List<Object?> get props => [grid, wordCoordinates];
}

class GridInitial extends GridState {}

class GridLoading extends GridState {}

class GridCreated extends GridState {
  final GridEntity grid;
  @override
  // ignore: overridden_fields
  final List<List<int>>? wordCoordinates;

  const GridCreated({required this.grid, this.wordCoordinates})
      : super(grid: grid, wordCoordinates: wordCoordinates);

  @override
  List<Object?> get props => [grid, wordCoordinates];
}

class GridError extends GridState {
  final String errorMessage;

  const GridError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
