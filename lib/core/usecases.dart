import 'package:dartz/dartz.dart';
import 'package:nirmitee/core/apperror.dart';

/// Base class for all use cases.
abstract class UseCase<Type, Params> {
  Future<Either<AppError, Type>> call(Params params);
}
