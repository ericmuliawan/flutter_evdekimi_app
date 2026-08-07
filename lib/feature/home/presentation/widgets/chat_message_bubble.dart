import 'package:flutter/material.dart';

import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';
import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUser = message.isUser;

    final background = isUser
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final foreground = isUser
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final radius = AppRadius.radius20;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing16,
          vertical: AppSpacing.spacing12,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(isUser ? radius : AppRadius.radius4),
            bottomRight: Radius.circular(isUser ? AppRadius.radius4 : radius),
          ),
        ),
        child: SelectableText(
          message.text,
          style: AppTextStyle.bodyMedium.apply(color: foreground),
        ),
      ),
    );
  }
}
