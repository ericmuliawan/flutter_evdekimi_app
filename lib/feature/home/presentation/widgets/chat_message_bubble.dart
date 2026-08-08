import 'package:flutter/material.dart';

import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';
import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.senderLabel,
  });

  final ChatMessage message;
  final String senderLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUser = message.isUser;
    final radius = AppRadius.radius20;

    final background = isUser
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final foreground = isUser
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final hasImage = message.imageBytes != null && message.imageBytes!.isNotEmpty;
    final hasText = message.text.trim().isNotEmpty;

    if (!hasImage && !hasText) return const SizedBox.shrink();

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            senderLabel,
            style: AppTextStyle.bodySmall.apply(
              color: colorScheme.onSurfaceVariant,
              fontWeightDelta: 2,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: hasText
                ? const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacing16,
                    vertical: AppSpacing.spacing12,
                  )
                : const EdgeInsets.all(AppSpacing.spacing8),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
                bottomLeft:
                    Radius.circular(isUser ? radius : AppRadius.radius4),
                bottomRight:
                    Radius.circular(isUser ? AppRadius.radius4 : radius),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.radius10),
                    child: Image.memory(
                      message.imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (hasImage && hasText)
                  const SizedBox(height: AppSpacing.spacing8),
                if (hasText)
                  SelectableText(
                    message.text,
                    style: AppTextStyle.bodyMedium.apply(color: foreground),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
