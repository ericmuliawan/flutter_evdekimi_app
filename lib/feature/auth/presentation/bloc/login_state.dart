import 'package:equatable/equatable.dart';

import 'package:flutter_evdekimi_app/feature/auth/data/models/login_response.dart';
import 'package:flutter_evdekimi_app/model/common/api_error.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess({required this.response});

  final LoginResponse response;

  @override
  List<Object?> get props => [response];
}

class LoginFailure extends LoginState {
  const LoginFailure({required this.error});

  final ApiError error;

  @override
  List<Object?> get props => [error];
}
