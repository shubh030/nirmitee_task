import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nirmitee/core/apperror.dart';
import 'package:nirmitee/domain/entities/grid_entities.dart';
import 'package:nirmitee/domain/repositories/grid_repositorie.dart';

@injectable
class CreateGridUseCase {
  final GridRepository repository;

  CreateGridUseCase(this.repository);

  Future<Either<AppError, GridEntity>> call(int rows, int cols) async {
    return await repository.createGrid(rows, cols);
  }
}
