import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Check if the device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Check if the device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Check if the device is a tablet based on screen width
  static bool isTablet(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final portraitWidth = mediaQuery.orientation == Orientation.portrait
        ? mediaQuery.size.width
        : mediaQuery.size.height;
    return portraitWidth >= 600 && portraitWidth < 1000; // Tablet width range
  }

  // Check if the device is a mobile based on screen width
  static bool isMobile(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final portraitWidth = mediaQuery.orientation == Orientation.portrait
        ? mediaQuery.size.width
        : mediaQuery.size.height;
    return portraitWidth < 600; // Mobile width range
  }
}

extension Sizes on num {
  SizedBox get height => SizedBox(
    height: toDouble(),
  );
  SizedBox get width => SizedBox(
    width: toDouble(),
  );
}