import 'package:equatable/equatable.dart';

enum ChatRole { user, assistant }

class ChatMessage extends Equatable {
  const ChatMessage({required this.role, required this.text});

  final ChatRole role;
  final String text;

  bool get isUser => role == ChatRole.user;

  ChatMessage copyWith({ChatRole? role, String? text}) {
    return ChatMessage(role: role ?? this.role, text: text ?? this.text);
  }

  @override
  List<Object?> get props => [role, text];
}
