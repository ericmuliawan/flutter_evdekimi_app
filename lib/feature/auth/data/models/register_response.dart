import 'package:equatable/equatable.dart';

class RegisterResponse extends Equatable {
  const RegisterResponse({this.message});

  final String? message;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(message: json['message']?.toString());

  @override
  List<Object?> get props => [message];
}
