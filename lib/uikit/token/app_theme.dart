import 'package:flutter/material.dart';

import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(_Palette.light, Brightness.light);

  static ThemeData get dark => _build(_Palette.dark, Brightness.dark);

  static ThemeData _build(_Palette palette, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: brightness,
    ).copyWith(
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      error: palette.error,
      onError: Colors.white,
      outline: palette.border,
      outlineVariant: palette.border,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radius10),
      borderSide: BorderSide(color: palette.border),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radius10),
      borderSide: BorderSide(color: palette.error),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      dividerColor: palette.divider,
      textTheme: _buildTextTheme(palette),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyle.title.apply(color: palette.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        hintStyle: AppTextStyle.bodyMedium.apply(color: palette.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing20,
          vertical: AppSpacing.spacing13,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: palette.primary),
        ),
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          elevation: 0,
          textStyle: AppTextStyle.labelButtonRegular,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radius10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radius10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: AppTextStyle.labelButtonRegular,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: palette.primary),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.radius20),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyle.subtitle.apply(color: palette.textPrimary),
        contentTextStyle: AppTextStyle.bodyLarge.apply(
          color: palette.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radius20),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(_Palette palette) {
    return TextTheme(
      displayLarge: AppTextStyle.displayLarge.apply(
        color: palette.textPrimary,
      ),
      displayMedium: AppTextStyle.displayMedium.apply(
        color: palette.textPrimary,
      ),
      displaySmall: AppTextStyle.displaySmall.apply(
        color: palette.textPrimary,
      ),
      headlineLarge: AppTextStyle.headlineLarge.apply(
        color: palette.textPrimary,
      ),
      headlineMedium: AppTextStyle.headlineMedium.apply(
        color: palette.textPrimary,
      ),
      headlineSmall: AppTextStyle.headlineSmall.apply(color: palette.primary),
      titleLarge: AppTextStyle.title.apply(color: palette.textPrimary),
      titleMedium: AppTextStyle.subtitle.apply(color: palette.textPrimary),
      titleSmall: AppTextStyle.smallTitle.apply(color: palette.textPrimary),
      bodyLarge: AppTextStyle.bodyLarge.apply(color: palette.textPrimary),
      bodyMedium: AppTextStyle.bodyMedium.apply(color: palette.textPrimary),
      bodySmall: AppTextStyle.bodySmall.apply(color: palette.textSecondary),
      labelLarge: AppTextStyle.labelButtonRegular.apply(
        color: palette.textPrimary,
      ),
      labelMedium: AppTextStyle.labelMedium.apply(color: palette.textPrimary),
      labelSmall: AppTextStyle.labelButtonSmall.apply(color: palette.textPrimary),
    );
  }
}

class _Palette {
  const _Palette({
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.divider,
    required this.primary,
    required this.onPrimary,
    required this.error,
  });

  final Color background;
  final Color surface;
  final Color onSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color divider;
  final Color primary;
  final Color onPrimary;
  final Color error;

  static const light = _Palette(
    background: AppColor.white,
    surface: AppColor.white,
    onSurface: AppColor.neutral,
    textPrimary: AppColor.neutral,
    textSecondary: AppColor.textSecondary,
    border: AppColor.neutralAlt,
    divider: AppColor.divider,
    primary: AppColor.primary,
    onPrimary: Colors.white,
    error: AppColor.error,
  );

  static const dark = _Palette(
    background: AppColor.mainBackgroundDark,
    surface: AppColor.whiteDark,
    onSurface: AppColor.neutralDark,
    textPrimary: AppColor.neutralDark,
    textSecondary: AppColor.textSecondaryDark,
    border: AppColor.neutralAltDark,
    divider: AppColor.dividerDark,
    primary: AppColor.primaryDark,
    onPrimary: AppColor.mainBackgroundDark,
    error: AppColor.errorDark,
  );
}
