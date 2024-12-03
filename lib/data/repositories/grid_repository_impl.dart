import 'package:dartz/dartz.dart';
import 'package:nirmitee/core/apperror.dart';
import 'package:nirmitee/data/data_source/grid_data_source.dart';
import 'package:nirmitee/domain/entities/grid_entities.dart';
import 'package:nirmitee/domain/repositories/grid_repositorie.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GridRepository)
class GridRepositoryImpl implements GridRepository {
  final GridDataSource dataSource;

  GridRepositoryImpl(this.dataSource);

  @override
  Future<Either<AppError, GridEntity>> createGrid(int rows, int cols) async {
    try {
      final grid = await dataSource.createGrid(rows, cols);
      return Right(GridEntity(grid));
    } catch (e) {
      return const Left(AppError('Failed to create grid'));
    }
  }
}
