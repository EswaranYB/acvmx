// import 'package:flutter/material.dart';
//
// class BarcodeScanProvider extends ChangeNotifier {
//   String? _barcode;
//   bool _isScanning = true;
//
//   double _blueLinePosition = 0;
//   bool _movingDown = true;
//
//   String? get barcode => _barcode;
//   bool get isScanning => _isScanning;
//   double get blueLinePosition => _blueLinePosition;
//
//   void setBarcode(String code) {
//     _barcode = code;
//     _isScanning = false;
//     notifyListeners();
//   }
//
//   void resetScanner() {
//     _barcode = null;
//     _isScanning = true;
//     notifyListeners();
//   }
//
//   // for blue line animation
//   void updateBlueLine() {
//     if (_movingDown) {
//       _blueLinePosition += 2;
//       if (_blueLinePosition >= 230) _movingDown = false;
//     } else {
//       _blueLinePosition -= 2;
//       if (_blueLinePosition <= 0) _movingDown = true;
//     }
//     notifyListeners();
//   }
//   void startAnimationLoop() {
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(milliseconds: 16));
//       updateBlueLine();
//       return true;
//     });
//   }
// //
//
//
// }
