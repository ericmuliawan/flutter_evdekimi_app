import 'package:flutter/material.dart';

import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Column(
      children: [
        Container(
          height: 76,
          width: 76,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(AppRadius.radius25),
            boxShadow: AppShadow.defaultShadow,
          ),
          child: Icon(Icons.home_rounded, color: onPrimary, size: 40),
        ),
        const SizedBox(height: AppSpacing.spacing16),
        Text(
          'EVDEKimi',
          textAlign: TextAlign.center,
          style: AppTextStyle.headlineMedium.copyWith(
            color: AppColor.neutralOf(context),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.title.apply(color: AppColor.neutralOf(context)),
        ),
        const SizedBox(height: AppSpacing.spacing8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyMedium.apply(
            color: AppColor.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}
