import 'package:dartz/dartz.dart';
import 'package:nirmitee/core/apperror.dart';
import 'package:nirmitee/domain/entities/grid_entities.dart';

abstract class GridRepository {
  Future<Either<AppError, GridEntity>> createGrid(int rows, int cols);
}
