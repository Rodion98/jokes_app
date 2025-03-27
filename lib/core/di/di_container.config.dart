// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/data/data_source/jokes_data_source.dart' as _i77;
import '../../features/data/mappers/joke_mapper.dart' as _i172;
import '../../features/data/repository_impl/jokes_repository_impl.dart'
    as _i841;
import '../../features/domain/repository/jokes_repository.dart' as _i44;
import '../../features/domain/use_case/fetch_jokes_by_type_use_case.dart'
    as _i230;
import '../../features/domain/use_case/fetch_jokes_use_case.dart' as _i18;
import '../dio/dio_module.dart' as _i977;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioModule = _$DioModule();
    gh.singleton<_i361.Dio>(() => dioModule.baseModule());
    gh.lazySingleton<_i172.JokeModelToEntityMapper>(
        () => _i172.JokeModelToEntityMapper());
    gh.singleton<_i77.JokesDataSource>(
        () => _i77.JokesDataSource(gh<_i361.Dio>()));
    gh.singleton<_i44.JokesRepository>(() => _i841.JokesRepositoryImpl(
          gh<_i77.JokesDataSource>(),
          gh<_i172.JokeModelToEntityMapper>(),
        ));
    gh.singleton<_i230.FetchJokesByTypeUseCase>(
        () => _i230.FetchJokesByTypeUseCase(gh<_i44.JokesRepository>()));
    gh.singleton<_i18.FetchJokesUseCase>(
        () => _i18.FetchJokesUseCase(gh<_i44.JokesRepository>()));
    return this;
  }
}

class _$DioModule extends _i977.DioModule {}
