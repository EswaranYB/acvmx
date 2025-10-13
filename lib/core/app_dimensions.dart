import 'dart:math';

import 'package:flutter/material.dart';



extension ColorExtension on Color {
  Color appWithValues({
    double? alpha,
    int? red,
    int? green,
    int? blue,
  }) {
    int originalValue = value;

    int a =
    alpha != null ? (alpha * 255).round() : (originalValue >> 24) & 0xFF;
    int r = red ?? (originalValue >> 16) & 0xFF;
    int g = green ?? (originalValue >> 8) & 0xFF;
    int b = blue ?? originalValue & 0xFF;

    return Color.fromARGB(a, r, g, b);
  }
}


extension MediaQueryExtension on BuildContext {
  /// Screen Dimensions
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get aspectRatio => MediaQuery.of(this).size.aspectRatio;

  /// Text Scaling
  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;

  /// Orientation
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Safe Area Insets
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Device Type (Responsive Helpers)
  bool get isMobile => screenWidth < 600;

  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  bool get isDesktop => screenWidth >= 1024;
}


extension StringExtension on String {
  String get capitalizeFirstLetter {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get toLowerCaseFirstLetter {
    if (isEmpty) return this;
    return '${this[0].toLowerCase()}${substring(1)}';
  }
}
class Rem {
  static double _baseWidth = 375;
  static double _baseHeight = 812;

  static double get scaleFactorWidth {
    final mediaQuery = MediaQueryData.fromView(WidgetsBinding.instance.window);
    return mediaQuery.size.width / _baseWidth;
  }

  static double get scaleFactorHeight {
    final mediaQuery = MediaQueryData.fromView(WidgetsBinding.instance.window);
    return mediaQuery.size.height / _baseHeight;
  }

  static double get scaleFactor => min(scaleFactorWidth, scaleFactorHeight);

  static double rem(double value) => value * scaleFactor;
}