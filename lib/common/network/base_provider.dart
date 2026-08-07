import 'package:dio/dio.dart';

import 'package:flutter_evdekimi_app/common/network/api_header_interceptor.dart';
import 'package:flutter_evdekimi_app/common/network/api_logger_interceptor.dart';
import 'package:flutter_evdekimi_app/data/env/env.dart';

class BaseProvider {
  BaseProvider({
    required ApiHeaderInterceptor apiHeaderInterceptor,
    required ApiLoggerInterceptor apiLoggerInterceptor,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );

    _dio.interceptors.addAll([
      apiHeaderInterceptor,
      apiLoggerInterceptor,
    ]);
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
