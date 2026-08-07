import 'package:dio/dio.dart';

import 'package:flutter_evdekimi_app/model/common/api_error.dart';
import 'package:flutter_evdekimi_app/model/common/api_result.dart';

extension ApiHandler on Response<dynamic> {
  ApiResult<T> parse<T>({T Function(Map<String, dynamic> data)? mapper}) {
    if (statusCode != null && statusCode! >= 200 && statusCode! < 300) {
      if (data is Map<String, dynamic>) {
        final mapped = mapper?.call(data);
        if (mapped != null) return ApiResult.success(mapped);
        return ApiResult.success(data as T);
      }
      return ApiResult.success(data as T);
    } else {
      final message = data is Map ? (data as Map)['message']?.toString() : null;
      return ApiResult.error(
        ApiError(code: statusCode, message: message),
      );
    }
  }
}
