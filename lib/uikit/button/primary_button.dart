import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../token/index.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  final bool isEnabled;
  final double height;
  final double? minWidth;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isEnabled = true,
    this.height = 50,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isEnabled ? onPressed : null,
      enableFeedback: isEnabled,
      height: height,
      minWidth: minWidth,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      elevation: 0,
      color: AppColor.purpleOf(context),
      disabledColor: AppColor.borderOf(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radius10),
      ),
      child: Text(
        buttonText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.labelButtonRegular.apply(
          color: isEnabled ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}

class PrimaryWhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  final bool isEnabled;
  final double height;
  final double? minWidth;

  const PrimaryWhiteButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isEnabled = true,
    this.height = 50,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isEnabled ? onPressed : null,
      enableFeedback: isEnabled,
      height: height,
      minWidth: minWidth,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      elevation: 0,
      color: AppColor.whiteOf(context),
      disabledColor: AppColor.buttonInactiveOf(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radius25),
        side: BorderSide(
          width: isEnabled ? 0 : 1,
          color: isEnabled
              ? AppColor.primary
              : AppColor.neutralAltOf(context),
        ),
      ),
      child: Text(
        buttonText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.labelButtonRegular.apply(
          color: AppColor.secondary,
        ),
      ),
    );
  }
}

class PrimaryButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  final bool isEnabled;
  final double height;
  final double? minWidth;

  const PrimaryButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isEnabled = true,
    this.height = 50,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: isEnabled ? onPressed : null,
        enableFeedback: isEnabled,
        height: height,
        minWidth: minWidth,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        elevation: 0,
        color: AppColor.purpleOf(context),
        disabledColor: AppColor.borderOf(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radius10),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            buttonText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.labelButtonRegular.apply(color: AppColor.white),
          ),
          const SizedBox(width: 10),
          Icon(Icons.arrow_forward_ios, color: AppColor.white)
        ]));
  }
}

class PrimaryButtonPurple extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  final bool isEnabled;
  final double height;
  final double? minWidth;

  const PrimaryButtonPurple({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isEnabled = true,
    this.height = 50,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: isEnabled ? onPressed : null,
        enableFeedback: isEnabled,
        height: height,
        minWidth: minWidth,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        elevation: 0,
        color: AppColor.purpleOf(context),
        disabledColor: HexColor("#35004E"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radius10),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            buttonText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.labelButtonRegular.apply(color: AppColor.white),
          ),
        ]));
  }
}

class PrimaryButtonPingpong extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  final bool isEnabled;
  final double height;
  final double? minWidth;

  const PrimaryButtonPingpong({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isEnabled = true,
    this.height = 50,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: isEnabled ? onPressed : null,
        enableFeedback: isEnabled,
        height: height,
        minWidth: minWidth,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        elevation: 0,
        color: Colors.transparent,
        disabledColor: AppColor.purpleOf(context),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: AppColor.white, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            buttonText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.labelButtonRegular.apply(color: AppColor.white),
          ),
        ]));
  }
}
