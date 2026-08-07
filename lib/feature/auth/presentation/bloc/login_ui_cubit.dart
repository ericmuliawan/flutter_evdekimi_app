import 'package:flutter_bloc/flutter_bloc.dart';

class LoginUiCubit extends Cubit<bool> {
  LoginUiCubit() : super(true);

  bool get isObscured => state;

  void togglePasswordVisibility() => emit(!state);
}
