import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jokes_app/core/error/failure.dart';
import 'package:jokes_app/core/use_case/base_use_case.dart';
import 'package:jokes_app/features/domain/entity/joke_entity.dart';
import 'package:jokes_app/features/domain/repository/jokes_repository.dart';

@singleton
final class FetchJokesUseCase extends UseCase<List<JokeEntity>, Null> {
  final JokesRepository _repository;
  FetchJokesUseCase(this._repository);
  @override
  Future<Either<Failure, List<JokeEntity>>> call(params) async {
    return await _repository.fetchJokes();
  }
}
