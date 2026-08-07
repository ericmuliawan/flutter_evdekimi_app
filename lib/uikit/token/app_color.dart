import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';

class AppColor {
  AppColor._();

  // ============================== LIGHT ==============================
  static const mainBackground = Color.fromARGB(255, 0, 0, 0);
  static const primary = Color(0xFF084B84);
  static const secondary = Color(0xFF55DDFF);
  static const tertiary = Color(0xFF1A72F6);
  static const trustPilotGreen = Color(0xFF05B67A);
  static const dusty = Color(0xFFC5DFE5);
  static const neutral = Color(0xFF444444);
  static const neutralAlt = Color(0xFFD3D3D3);
  static const error = Color.fromARGB(255, 241, 1, 1);
  static const buttonInactive = Color(0xFFE5E5E5);
  static const labelGray = Color(0xFFB1B1B1);
  static const errorSnackbarBackground = Color(0xFFFDEDEE);
  static const divider = Color(0xFFF3F9FA);
  static const textSecondary = Color(0xFF5E5E5E);
  static const textFieldBackgroundFilled = Color(0xFFEEFCFF);
  static const ratingEnable = Color(0xFFFFB800);
  static const ratingDisable = Color(0xFFD3D3D3);
  static const shadowFull = Color(0xFF18274B);
  static const facebook = Color(0xFF1877F2);
  static Color blackagb = HexColor('#000000');
  static Color purpleagbbackground = HexColor('#C42BDD');
  static Color purpleagb = HexColor('#b100cd');
  static Color greenagb = HexColor('#005518');
  static Color blueagb = HexColor('#084B84');
  static const Color primarySoft = Color(0xFFEAEAF2);
  static Color greensecondary = HexColor('#6AB536');
  static Color blueagbSecond = HexColor('#45BEDC');
  static Color blueagbThird = HexColor('#C5F5FF');
  static Color blueagbFour = HexColor('#E9F2F9');
  static const Color border = Color(0xFFD3D3E4);
  static Color priceagb = HexColor('#D9480A');
  static Color divideragb = HexColor('#F2F6F9');
  static Color chatagb = HexColor('#009DF5');
  static const Color white = Color(0xFFFFFFFF);
  static Color greenbullet = HexColor('#6AB536');
  static Color greenSnackBar = HexColor('#00A30B');
  static Color greenNotif = HexColor('#D0F0C0');
  static Color bluebullet = HexColor('#45BEDC');
  static Color redbullet = HexColor('#FF0000');
  static Color redNotif = HexColor('#ffb3b3');
  static Color redSnackbar = HexColor('#1E0A27');
  static Color redBarInfo = HexColor('#BF0E45');
  static Color navyBarInfo = HexColor('#1E0A27');
  static Color greybullet = HexColor('#D3D3D3');
  static Color unguagb = HexColor('#4200FF');
  static Color orangeagb = HexColor('#ffaf7a');
  static Color purplesoftAgb = HexColor('#FBF4FF');
  static Color purpleAgb2 = HexColor('#F7E9FF');
  static Color greenAgbWA = HexColor('#34C759');

  // =============================== DARK ==============================
  static const mainBackgroundDark = Color(0xFF121212);
  static const primaryDark = Color(0xFF4FA8E8);
  static const secondaryDark = Color(0xFF55DDFF);
  static const tertiaryDark = Color(0xFF6FB8FF);
  static const trustPilotGreenDark = Color(0xFF05B67A);
  static const dustyDark = Color(0xFF2E3A3D);
  static const neutralDark = Color(0xFFE6E6E6);
  static const neutralAltDark = Color(0xFF3A3A3A);
  static const errorDark = Color(0xFFF26D6D);
  static const buttonInactiveDark = Color(0xFF2E2E2E);
  static const labelGrayDark = Color(0xFF9E9E9E);
  static const errorSnackbarBackgroundDark = Color(0xFF3D1B1C);
  static const dividerDark = Color(0xFF2A2A2A);
  static const textSecondaryDark = Color(0xFF9E9E9E);
  static const textFieldBackgroundFilledDark = Color(0xFF1C2E38);
  static const ratingEnableDark = Color(0xFFFFB800);
  static const ratingDisableDark = Color(0xFF3A3A3A);
  static const shadowFullDark = Color(0xFF000000);
  static const facebookDark = Color(0xFF1877F2);
  static Color blackagbDark = HexColor('#E6E6E6');
  static Color purpleagbbackgroundDark = HexColor('#8E24AA');
  static Color purpleagbDark = HexColor('#D97BEE');
  static Color greenagbDark = HexColor('#66BB6A');
  static Color blueagbDark = HexColor('#4FA8E8');
  static const Color primarySoftDark = Color(0xFF2A2A3A);
  static Color greensecondaryDark = HexColor('#81C784');
  static Color blueagbSecondDark = HexColor('#4FC3F7');
  static Color blueagbThirdDark = HexColor('#17343E');
  static Color blueagbFourDark = HexColor('#1B2A36');
  static const Color borderDark = Color(0xFF3A3A3A);
  static Color priceagbDark = HexColor('#FF8A50');
  static Color divideragbDark = HexColor('#2A2A2A');
  static Color chatagbDark = HexColor('#4FC3F7');
  static const Color whiteDark = Color(0xFF1E1E1E);
  static Color greenbulletDark = HexColor('#81C784');
  static Color greenSnackBarDark = HexColor('#4CAF50');
  static Color greenNotifDark = HexColor('#1E3A20');
  static Color bluebulletDark = HexColor('#4FC3F7');
  static Color redbulletDark = HexColor('#FF6B6B');
  static Color redNotifDark = HexColor('#3D1B1C');
  static Color redSnackbarDark = HexColor('#000000');
  static Color redBarInfoDark = HexColor('#BF0E45');
  static Color navyBarInfoDark = HexColor('#000000');
  static Color greybulletDark = HexColor('#3A3A3A');
  static Color unguagbDark = HexColor('#9C7BFF');
  static Color orangeagbDark = HexColor('#FFAF7A');
  static Color purplesoftAgbDark = HexColor('#2A1B36');
  static Color purpleAgb2Dark = HexColor('#33203D');
  static Color greenAgbWADark = HexColor('#34C759');

  // ====================== THEME-AWARE ACCESSORS ======================
  static Color themeAware(
    BuildContext context, {
    required Color light,
    required Color dark,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  static Color whiteOf(BuildContext context) =>
      themeAware(context, light: white, dark: whiteDark);

  static Color neutralOf(BuildContext context) =>
      themeAware(context, light: neutral, dark: neutralDark);

  static Color neutralAltOf(BuildContext context) =>
      themeAware(context, light: neutralAlt, dark: neutralAltDark);

  static Color purpleOf(BuildContext context) =>
      themeAware(context, light: purpleagb, dark: purpleagbDark);

  static Color borderOf(BuildContext context) =>
      themeAware(context, light: border, dark: borderDark);

  static Color buttonInactiveOf(BuildContext context) =>
      themeAware(context, light: buttonInactive, dark: buttonInactiveDark);

  static Color textSecondaryOf(BuildContext context) =>
      themeAware(context, light: textSecondary, dark: textSecondaryDark);
}
