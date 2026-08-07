import 'package:flutter/material.dart';

import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isGenerating,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isGenerating;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing12,
        AppSpacing.spacing16,
        AppSpacing.spacing12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => isGenerating ? null : onSend(),
              decoration: InputDecoration(
                hintText: 'Ask EVDEKimi AI...',
                fillColor: colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing20,
                  vertical: AppSpacing.spacing12,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.radius25),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.radius25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.spacing12),
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              onPressed: isGenerating ? null : onSend,
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primary,
                disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.onPrimary,
                disabledForegroundColor: colorScheme.onSurfaceVariant,
              ),
              icon: isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_upward_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
