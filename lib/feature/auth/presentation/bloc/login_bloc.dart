import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_evdekimi_app/feature/auth/data/models/login_request.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/models/login_response.dart';
import 'package:flutter_evdekimi_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/login_event.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/login_state.dart';
import 'package:flutter_evdekimi_app/model/common/api_result.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final IAuthRepository _authRepository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final result = await _authRepository.login(
      LoginRequest(email: event.email, password: event.password),
    );

    switch (result) {
      case Success<LoginResponse>(:final response):
        emit(LoginSuccess(response: response));
      case Error<LoginResponse>(:final error):
        emit(LoginFailure(error: error));
    }
  }
}
