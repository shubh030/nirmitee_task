import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:nirmitee/core/apperror.dart';
import 'package:nirmitee/domain/entities/grid_entities.dart';
import 'package:nirmitee/domain/usecases/create_grid_usecase.dart';

part 'grid_state.dart';

@injectable
class GridCubit extends Cubit<GridState> {
  final CreateGridUseCase _createGridUseCase;

  GridCubit(this._createGridUseCase) : super(GridInitial());

  Future<void> createGrid(int rows, int cols) async {
    emit(GridLoading());

    final Either<AppError, GridEntity> result =
        await _createGridUseCase(rows, cols);

    result.fold(
      (failure) {
        emit(GridError(errorMessage: failure.message));
      },
      (grid) {
        emit(GridCreated(grid: grid));
      },
    );
  }

  Future<void> searchWord(String word) async {
    if (state is! GridCreated) return;

    final currentGrid = (state as GridCreated).grid.grid;
    final wordCoordinates = _findWordCoordinates(word, currentGrid);

    if (wordCoordinates.isNotEmpty) {
      emit(GridCreated(
        grid: (state as GridCreated).grid,
        wordCoordinates: wordCoordinates,
      ));
    } else {
      emit(GridCreated(
        grid: (state as GridCreated).grid,
        wordCoordinates: [],
      ));
    }
  }

  bool _checkDiagonal(
    List<List<String>> grid,
    String word,
    int row,
    int col, {
    required bool isRightDiagonal,
  }) {
    for (int i = 0; i < word.length; i++) {
      final newRow = row + i;
      final newCol = isRightDiagonal ? col + i : col - i;

      if (newRow >= grid.length || newCol < 0 || newCol >= grid[0].length) {
        return false;
      }

      if (grid[newRow][newCol].toUpperCase() != word[i].toUpperCase()) {
        return false;
      }
    }
    return true;
  }

  List<List<int>> _findWordCoordinates(String word, List<List<String>> grid) {
    final List<List<int>> coordinates = [];
    final upperWord = word.toUpperCase();

    // Horizontal search
    for (int row = 0; row < grid.length; row++) {
      final rowStr = grid[row].join();
      int index = rowStr.indexOf(upperWord);
      if (index != -1) {
        for (int i = 0; i < word.length; i++) {
          coordinates.add([row, index + i]);
        }
        return coordinates;
      }
    }

    // Vertical search
    for (int col = 0; col < grid[0].length; col++) {
      String column = '';
      for (int row = 0; row < grid.length; row++) {
        column += grid[row][col];
      }
      int index = column.indexOf(upperWord);
      if (index != -1) {
        for (int i = 0; i < word.length; i++) {
          coordinates.add([index + i, col]);
        }
        return coordinates;
      }
    }

    // Diagonal left-to-right search
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[0].length; col++) {
        if (_checkDiagonal(grid, upperWord, row, col, isRightDiagonal: true)) {
          for (int i = 0; i < word.length; i++) {
            coordinates.add([row + i, col + i]);
          }
          return coordinates;
        }
      }
    }

    // Diagonal right-to-left search
    for (int row = 0; row < grid.length; row++) {
      for (int col = grid[0].length - 1; col >= 0; col--) {
        if (_checkDiagonal(grid, upperWord, row, col, isRightDiagonal: false)) {
          for (int i = 0; i < word.length; i++) {
            coordinates.add([row + i, col - i]);
          }
          return coordinates;
        }
      }
    }

    return coordinates;
  }
}
