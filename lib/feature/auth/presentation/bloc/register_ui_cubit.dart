import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterUiCubit extends Cubit<bool> {
  RegisterUiCubit() : super(true);

  bool get isObscured => state;

  void togglePasswordVisibility() => emit(!state);
}
