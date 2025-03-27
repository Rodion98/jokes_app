import 'package:jokes_app/core/constants/code_responces.dart';
import 'package:jokes_app/core/constants/data_source_enum.dart';
import 'package:jokes_app/core/error/failure.dart';

import '../constants/network_constants.dart';

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return const DefaultFailure(ResponseCode.success, success);

      case DataSource.noContent:
        return const DefaultFailure(ResponseCode.noContent, success);

      case DataSource.badRequest:
        return const ServerFailure(ResponseCode.badRequest, strBadRequestError);

      case DataSource.forbidden:
        return const ServerFailure(ResponseCode.forbidden, strForbiddenError);

      case DataSource.unauthorised:
        return const ServerFailure(
          ResponseCode.unauthorized,
          strUnauthorizedError,
        );

      case DataSource.notFound:
        return const ServerFailure(ResponseCode.notFound, strNotFoundError);

      case DataSource.internalServerError:
        return const ServerFailure(
          ResponseCode.iternalServerError,
          strInternalServerError,
        );

      case DataSource.connectionTimeout:
        return const NetworkFailure(
          ResponseCode.connectTimeOut,
          strTimeoutError,
        );

      case DataSource.cancel:
        return const DefaultFailure(ResponseCode.cancel, strDefaultError);

      case DataSource.receiveTimeout:
        return const NetworkFailure(
          ResponseCode.receiveTimeout,
          strTimeoutError,
        );

      case DataSource.sendTimeout:
        return const NetworkFailure(ResponseCode.sendTimeout, strTimeoutError);

      case DataSource.cacheError:
        return const CacheFailure(ResponseCode.cacheError, strCacheError);

      case DataSource.noInternetConnection:
        return const NetworkFailure(
          ResponseCode.noInternetConnection,
          strNoInternetError,
        );

      case DataSource.defaultError:
        return const DefaultFailure(ResponseCode.defaultError, strDefaultError);
    }
  }
}
