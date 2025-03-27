import 'package:dio/dio.dart';
import 'package:jokes_app/core/constants/code_responces.dart';
import 'package:jokes_app/core/constants/data_source_enum.dart';
import 'package:jokes_app/core/constants/network_constants.dart';
import 'package:jokes_app/core/error/data_source_extension.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleError(error);
    } else {
      return DataSource.defaultError.getFailure();
    }
  }
}

Failure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.connectionTimeout.getFailure();

    case DioExceptionType.sendTimeout:
      return DataSource.sendTimeout.getFailure();

    case DioExceptionType.receiveTimeout:
      return DataSource.receiveTimeout.getFailure();

    case DioExceptionType.badResponse:
      return _handleBadResponse(error);

    case DioExceptionType.cancel:
      return DataSource.cancel.getFailure();

    case DioExceptionType.connectionError:
      return DataSource.noInternetConnection.getFailure();

    default:
      return DataSource.defaultError.getFailure();
  }
}

Failure _handleBadResponse(DioException error) {
  final response = error.response;
  return ServerFailure(
    response?.statusCode ?? ResponseCode.defaultError,
    response?.statusMessage ?? strDefaultError,
  );
}

extension FailureWhen on Failure {
  T when<T>({
    required T Function(ServerFailure) server,
    required T Function(NetworkFailure) network,
    required T Function(CacheFailure) cache,
    required T Function(DefaultFailure) defaultFailure,
  }) {
    switch (this) {
      case ServerFailure():
        return server(this as ServerFailure);
      case NetworkFailure():
        return network(this as NetworkFailure);
      case CacheFailure():
        return cache(this as CacheFailure);
      case DefaultFailure():
        return defaultFailure(this as DefaultFailure);
    }
  }
}
