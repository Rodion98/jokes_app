import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:jokes_app/core/constants/network_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @singleton
  Dio baseModule() {
    final dioClient = _dioClient();

    if (kDebugMode) {
      _prettyDioLogger(dioClient);
    }

    return dioClient;
  }

  Dio _dioClient() {
    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: requestTimeOut,
      receiveTimeout: requestTimeOut,
    );
    return Dio(baseOptions);
  }

  void _prettyDioLogger(Dio dioClient) {
    dioClient.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }
}
