import 'package:flutter/material.dart';

import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key, required this.onSuggestionTap});

  final ValueChanged<String> onSuggestionTap;

  static const _suggestions = [
    'Who is at home right now?',
    'How does EVDEKimi work?',
    'Set a reminder for me',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                size: 36,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing20),
            Text(
              'Meet EVDEKimi AI',
              style: AppTextStyle.smallTitle.apply(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              'Your smart home assistant. Ask me anything!',
              style: AppTextStyle.bodyMedium.apply(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spacing24),
            Wrap(
              spacing: AppSpacing.spacing8,
              runSpacing: AppSpacing.spacing8,
              alignment: WrapAlignment.center,
              children: [
                for (final suggestion in _suggestions)
                  ActionChip(
                    onPressed: () => onSuggestionTap(suggestion),
                    label: Text(
                      suggestion,
                      style: AppTextStyle.bodySmall.apply(
                        color: colorScheme.primary,
                      ),
                    ),
                    backgroundColor: colorScheme.primary.withValues(
                      alpha: 0.08,
                    ),
                    side: BorderSide(color: colorScheme.primary.withValues(
                      alpha: 0.2,
                    )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.radius20),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
