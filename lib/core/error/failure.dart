import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final int code;
  final String message;

  const Failure(this.code, this.message);

  @override
  List<Object?> get props => [code, message];
}

final class ServerFailure extends Failure {
  const ServerFailure(super.code, super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.code, super.message);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.code, super.message);
}

final class DefaultFailure extends Failure {
  const DefaultFailure(super.code, super.message);
}
