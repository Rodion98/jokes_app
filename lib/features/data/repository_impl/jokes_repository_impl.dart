import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jokes_app/core/constants/code_responces.dart';
import 'package:jokes_app/core/constants/network_constants.dart';
import 'package:jokes_app/core/error/exception_handler.dart';
import 'package:jokes_app/core/error/failure.dart';
import 'package:jokes_app/core/utils/network_utils.dart';
import 'package:jokes_app/features/data/data_source/jokes_data_source.dart';
import 'package:jokes_app/features/data/mappers/joke_mapper.dart';
import 'package:jokes_app/features/domain/entity/joke_entity.dart';
import 'package:jokes_app/features/domain/repository/jokes_repository.dart';

@Singleton(as: JokesRepository)
class JokesRepositoryImpl implements JokesRepository {
  final JokesDataSource _dataSource;
  final JokeModelToEntityMapper _mapper;
  JokesRepositoryImpl(this._dataSource, this._mapper);
  @override
  Future<Either<Failure, List<JokeEntity>>> fetchJokes() async {
    if (!await NetworkChecker.hasConnection()) {
      return const Left(
        NetworkFailure(
          ResponseCode.noInternetConnection,
          strNoInternetError,
        ),
      );
    }

    try {
      final httpResponse = await _dataSource.fetchJokes(
          // params.startDate,
          // params.endDate,
          );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final jokes = (httpResponse.data).map(_mapper.map).toList();
        return Right(jokes);
      } else {
        return Left(
          ServerFailure(
            httpResponse.response.statusCode ?? ResponseCode.defaultError,
            httpResponse.response.statusMessage ?? strDefaultError,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<JokeEntity>>> fetchJokesByType(
      String type) async {
    if (!await NetworkChecker.hasConnection()) {
      return const Left(
        NetworkFailure(
          ResponseCode.noInternetConnection,
          strNoInternetError,
        ),
      );
    }

    try {
      final httpResponse = await _dataSource.fetchJokesByType(type);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final jokes = (httpResponse.data).map(_mapper.map).toList();
        return Right(jokes);
      } else {
        return Left(
          ServerFailure(
            httpResponse.response.statusCode ?? ResponseCode.defaultError,
            httpResponse.response.statusMessage ?? strDefaultError,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
