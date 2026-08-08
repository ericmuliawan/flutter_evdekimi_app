import 'dart:typed_data';

import 'package:equatable/equatable.dart';

enum ChatRole { user, assistant }

class ChatMessage extends Equatable {
  const ChatMessage({
    this.id,
    required this.role,
    required this.text,
    this.imageBytes,
    this.imageMimeType,
    this.createdAt,
  });

  final int? id;
  final ChatRole role;
  final String text;
  final Uint8List? imageBytes;
  final String? imageMimeType;
  final DateTime? createdAt;

  bool get isUser => role == ChatRole.user;

  ChatMessage copyWith({
    int? id,
    ChatRole? role,
    String? text,
    Uint8List? imageBytes,
    String? imageMimeType,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      text: text ?? this.text,
      imageBytes: imageBytes ?? this.imageBytes,
      imageMimeType: imageMimeType ?? this.imageMimeType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    role,
    text,
    imageBytes,
    imageMimeType,
    createdAt,
  ];
}
