import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter'
    );
  }
}

class CustomTextStyles {
  // Body text style
  static TextStyle get bodyMediumBluegray100 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray100,
        fontSize: 14.fSize,
      );

  static TextStyle get bodyMediumBluegray300 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray300,
      );

  static TextStyle get bodyMediumBluegray300_1 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray300,
      );

  static TextStyle get bodyMediumBluegray300_2 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray300,
      );

  static TextStyle get bodyMediumDeeppurpleA200 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.deepPurpleA200,
      );

  static TextStyle get bodyMediumLightBlue =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.lightBlue,
      );

  static TextStyle get bodyMediumGray200 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray200,
      );
  static TextStyle get bodyMediumOnPrimaryContainer =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );

  static TextStyle get bodyMediumOnPrimaryContainer_1 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );

  static TextStyle get bodyMediumPrimary =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
      );

  static TextStyle get bodyMediumPrimary14 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 14.fSize,
      );

  static TextStyle get bodyMediumPrimary_1 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
      );

  static TextStyle get bodyMediumRed300 => theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.red300,
  );

  static TextStyle get bodyMediumRed300_1 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.red300,
      );

  static TextStyle get bodyMediumRed600 => theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.red600,
  );
  static TextStyle get bodyMediumRed600_1 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.red600,
      );

  static TextStyle get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
    color: appTheme.black900,
  );

// Headline text style
  static TextStyle get headlineSmallOnPrimaryContainer =>
      theme.textTheme.headlineSmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );

// Inter text style
  static TextStyle get interOnPrimaryContainer => TextStyle(
    color: theme.colorScheme.onPrimaryContainer,
    fontSize: 111.fSize,
    fontWeight: FontWeight.w800,
  ).inter;

// Label text style
  static TextStyle get labelLargePrimary =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w500,
      );

// Title text style
  static TextStyle get titleMediumDeeppurpleA200 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.deepPurpleA200,
      );
  static TextStyle get titleMediumOnPrimaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 16.fSize,
      );

  static TextStyle get titleSmallOnPrimaryContainer =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );

  static TextStyle get titleSmallPrimary =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
      );

  static TextStyle get titleProductBlack =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900
      );

}