import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_evdekimi_app/feature/auth/data/models/register_request.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/models/register_response.dart';
import 'package:flutter_evdekimi_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/register_event.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/bloc/register_state.dart';
import 'package:flutter_evdekimi_app/model/common/api_result.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  final IAuthRepository _authRepository;

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());

    final result = await _authRepository.register(
      RegisterRequest(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      ),
    );

    switch (result) {
      case Success<RegisterResponse>(:final response):
        emit(RegisterSuccess(response: response));
      case Error<RegisterResponse>(:final error):
        emit(RegisterFailure(error: error));
    }
  }
}
