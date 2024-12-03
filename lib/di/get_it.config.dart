// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/data_source/grid_data_source.dart' as _i477;
import '../data/repositories/grid_repository_impl.dart' as _i938;
import '../domain/repositories/grid_repositorie.dart' as _i219;
import '../domain/usecases/create_grid_usecase.dart' as _i803;
import '../presentation/cubits/grid_cubit/grid_cubit.dart' as _i208;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i477.GridDataSource>(() => _i477.GridDataSource());
  gh.lazySingleton<_i219.GridRepository>(
      () => _i938.GridRepositoryImpl(gh<_i477.GridDataSource>()));
  gh.factory<_i803.CreateGridUseCase>(
      () => _i803.CreateGridUseCase(gh<_i219.GridRepository>()));
  gh.factory<_i208.GridCubit>(
      () => _i208.GridCubit(gh<_i803.CreateGridUseCase>()));
  return getIt;
}
