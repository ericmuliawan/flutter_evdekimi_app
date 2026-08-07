import 'package:equatable/equatable.dart';

import 'package:flutter_evdekimi_app/feature/auth/data/models/register_response.dart';
import 'package:flutter_evdekimi_app/model/common/api_error.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess({required this.response});

  final RegisterResponse response;

  @override
  List<Object?> get props => [response];
}

class RegisterFailure extends RegisterState {
  const RegisterFailure({required this.error});

  final ApiError error;

  @override
  List<Object?> get props => [error];
}
