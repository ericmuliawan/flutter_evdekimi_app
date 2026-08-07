import 'package:dio/dio.dart';

import 'package:flutter_evdekimi_app/common/local_storage_provider.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/models/login_request.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/models/login_response.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/models/register_request.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/models/register_response.dart';
import 'package:flutter_evdekimi_app/model/common/api_error.dart';
import 'package:flutter_evdekimi_app/model/common/api_result.dart';

abstract class IAuthRepository {
  Future<ApiResult<LoginResponse>> login(LoginRequest request);
  Future<ApiResult<RegisterResponse>> register(RegisterRequest request);
}

class AuthRepository implements IAuthRepository {
  AuthRepository({
    required IAuthRemoteDataSource remoteDataSource,
    required ILocalStorageProvider localStorageProvider,
  }) : _remoteDataSource = remoteDataSource,
       _localStorageProvider = localStorageProvider;

  final IAuthRemoteDataSource _remoteDataSource;
  final ILocalStorageProvider _localStorageProvider;

  @override
  Future<ApiResult<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _remoteDataSource.login(request);

      if (response.token != null && response.token!.isNotEmpty) {
        await _localStorageProvider.setAuthToken(response.token!);
      }
      await _localStorageProvider.setUserEmail(request.email);
      await _localStorageProvider.setUserLogin(true);

      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.error(
        ApiError(
          code: e.response?.statusCode,
          message: _serverMessage(e) ?? 'Login failed',
        ),
      );
    } catch (e) {
      return ApiResult.error(ApiError(message: e.toString()));
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.register(request);
      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.error(
        ApiError(
          code: e.response?.statusCode,
          message: _serverMessage(e) ?? 'Registration failed',
        ),
      );
    } catch (e) {
      return ApiResult.error(ApiError(message: e.toString()));
    }
  }

  String? _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      return data['error']?.toString() ?? data['message']?.toString();
    }
    return null;
  }
}
