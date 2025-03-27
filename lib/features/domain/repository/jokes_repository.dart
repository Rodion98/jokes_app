import 'package:dartz/dartz.dart';
import 'package:jokes_app/core/error/failure.dart';
import 'package:jokes_app/features/domain/entity/joke_entity.dart';

abstract interface class JokesRepository {
  Future<Either<Failure, List<JokeEntity>>> fetchJokes();
  Future<Either<Failure, List<JokeEntity>>> fetchJokesByType(String type);
}
