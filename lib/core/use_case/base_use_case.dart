import 'package:dartz/dartz.dart';
import 'package:jokes_app/core/error/failure.dart';

abstract base class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
