import 'package:flutter/material.dart';

const num FIGMA_DESIGN_WIDTH = 393;
const num FIGMA_DESIGN_HEIGHT = 852;

extension ResposiveExtension on num {
  double get _width => SizeUtils.width;
  double get h => ((this * _width) / FIGMA_DESIGN_WIDTH);
  double get fSize => ((this * _width) / FIGMA_DESIGN_WIDTH);
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
    BuildContext context,
    Orientation orientation,
    DeviceType deviceType
    );

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});
  final ResponsiveBuild builder;

  // Builds the widget whenever the orientation changes.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}


class SizeUtils {
  static late BoxConstraints boxConstraints;

  static late Orientation orientation;

  static late DeviceType deviceType;

  static late double width;
  static late double height;

  static void setScreenSize(
      BoxConstraints constrains,
      Orientation currentOrientation
    ) {
      boxConstraints = constrains;
      orientation = currentOrientation;
      if (orientation == Orientation.portrait) {
        width = boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      } else {
        width = boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      }
      deviceType = DeviceType.mobile;
  }
}