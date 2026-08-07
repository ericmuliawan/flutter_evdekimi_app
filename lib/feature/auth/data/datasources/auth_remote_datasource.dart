import 'package:dio/dio.dart';

import 'package:flutter_evdekimi_app/feature/auth/data/models/login_request.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/models/login_response.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/models/register_request.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/models/register_response.dart';

abstract class IAuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  static const _loginPath = '/api/login';
  static const _registerPath = '/api/register';

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(_loginPath, data: request.toJson());

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: _errorMessage(response.data) ?? 'Login failed',
    );
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _dio.post(_registerPath, data: request.toJson());

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return RegisterResponse.fromJson(response.data as Map<String, dynamic>);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: _errorMessage(response.data) ?? 'Registration failed',
    );
  }

  String? _errorMessage(dynamic data) {
    if (data is Map) {
      return data['error']?.toString() ?? data['message']?.toString();
    }
    return null;
  }
}
