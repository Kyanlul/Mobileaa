import 'package:flutter/material.dart';
import '../core/app_export.dart';

String _appTheme = 'lightCOde';
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

class ThemeHelper {
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };
  
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  void changeTheme(String newTheme) {
    _appTheme = newTheme;
  }
  
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }
  
  ThemeData _getThemeData() {
    var colorScheme = 
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: appTheme.gray50,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        side: BorderSide(
          color: appTheme.blueGray100,
          width: 1
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
    );
  }
  
  LightCodeColors themeColor() => _getThemeColors();
  
  ThemeData themeData() => _getThemeData();
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    bodyMedium: TextStyle(
      color: appTheme.black900,
      fontSize: 13.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: appTheme.blueGray100,
      fontSize: 11.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
    ),
    displayLarge: TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 33.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w800,
    ),
    displayMedium: TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 50.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w800,
    ),
    headlineSmall: TextStyle(
      color: appTheme.black900,
      fontSize: 24.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    ),
    labelLarge: TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 13.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      color: appTheme.deepPurpleA200,
      fontSize: 11.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: appTheme.black900,
      fontSize: 18.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: appTheme.deepPurpleA200,
      fontSize: 14.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    ),
  );
}

class ColorSchemes {
  static const lightCodeColorScheme = ColorScheme.light(
    primary: Color(0xFF2196F3),
    secondaryContainer: Color(0XFFFF9E3F),
    onPrimary: Color(0XFFD80027),
    onPrimaryContainer: Color(0XFFFFFFFF),
  );
}

class LightCodeColors {
  Color get amberA200 => const Color(0XFFFFDA44);
  Color get black900 => const Color(0XFF000000);
  Color get blueGray100 => const Color(0XFFD2D6DB);
  Color get blueGray300 => const Color(0XFF9DA4AE);
  Color get deepPurpleA200 => const Color(0XFF8C68EE);
  Color get gray200 => const Color(0XFFE5E7EB);
  Color get gray50 => const Color(0XFFFCFCFD);
  Color get gray5001 => const Color(0XFFF9FAFB);
  Color get orange100 => const Color(0XFFFBD5B1);
  Color get orangeA200 => const Color(0XFFFA993B);
  Color get red300 => const Color(0XFFB77855);
  Color get red600 => const Color(0XFFDA4531);
  Color get whiteA700 => const Color(0XFFFFFFFF);
  Color get lightGray => const Color(0xFFF5F5F5);
  Color get lightBlue => const Color(0xFF42A5F5);
}
