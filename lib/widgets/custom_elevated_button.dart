import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'base_button.dart';


class CustomElevatedButton extends BaseButton {
  const CustomElevatedButton({super.key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    super.margin,
    super.onPressed,
    super.buttonStyle,
    super.alignment,
    super.buttonTextStyle,
    super.isDisabled,
    super.height,
    super.width,
    required super.text});

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,  // Điều kiện kiểm tra lại thừa
      child: buildElevatedButtonWidget,
    )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
    height: height ?? 44.h,
    width: width ?? double.maxFinite,
    margin: margin,
    decoration: decoration,
    child: ElevatedButton(
        onPressed: isDisabled ?? false ? null : onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leftIcon != null)
              Padding(
                padding: EdgeInsets.only(right: 20.h),
                child: leftIcon!,
              ),
            Text(
              text,
              style: buttonTextStyle ?? CustomTextStyles.titleMediumOnPrimaryContainer,
            ),
            if (rightIcon != null)
              Padding(
                padding: EdgeInsets.only(left: 20.h),
                child: rightIcon!,
              ),
          ],
        )
    ),
  );

}