import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  const LoginResponse({this.token, this.user});

  final String? token;
  final String? user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json['token']?.toString(),
    user: json['user']?.toString(),
  );

  @override
  List<Object?> get props => [token, user];
}
