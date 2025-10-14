import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:acvmx/feature/Dashboard/model/get_product_detail_by_serial_number_model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Network/api_manager.dart';
import '../../../Network/api_response.dart';
import '../../../Network/api_service.dart';
import '../../../core/app_decoration.dart';
import '../../../core/helper/app_log.dart';
import '../../../core/routes/route_name.dart';
import 'package:go_router/go_router.dart';

// class ProductDetailProvider with ChangeNotifier {
//   final BaseApiManager apiManager = BaseApiManager();
//   late final ApiServices _apiServices;
//
//   ProductDetailProvider() {
//     _apiServices = ApiServices(apiManager: apiManager);
//   }
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   ProductDetailsBySerialNumberResponse? _productDetailsBySerialNumberResponse;
//   ProductDetailsBySerialNumberResponse? get productDetailsBySerialNumber => _productDetailsBySerialNumberResponse;
//
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
//   // Blue line animation
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
//
//   void startAnimationLoop() {
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(milliseconds: 16));
//       updateBlueLine();
//       return true;
//     });
//   }
//
//   Future<bool> startBarcodeScan(BuildContext context) async {
//     final permissionGranted = await checkAndRequestCameraPermission(context);
//     if (!permissionGranted) {
//       return false;
//     }
//     resetScanner();
//     return true;
//
//   }
//   // Main handler: Called from onDetect
//   Future<void> handleSerialNumberScan(BuildContext context, String serialNumber) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       ApiResponse response = await _apiServices.getProductDetailBySerialNumber(serialNumber);
//
//       if (response.status == 200 && response.data != null) {
//         _productDetailsBySerialNumberResponse =
//             ProductDetailsBySerialNumberResponse.fromJson(response.data!);
//
//         debugPrint("Product Details Fetched: ${_productDetailsBySerialNumberResponse?.productName}");
//
//         if (context.mounted) {
//           context.pushNamed(
//             RouteName.productDetailsScreen,
//             extra: _productDetailsBySerialNumberResponse,
//           );
//         }
//       } else {
//         _productDetailsBySerialNumberResponse = null;
//
//         if (context.mounted) {
//           showSnackBar(context, 'Invalid Serial Number. No product found.');
//           context.goNamed(
//             RouteName.dashboardScreen,
//             pathParameters: {'userType': 'customer'},
//             queryParameters: {'tab': '0'},
//           );
//         }
//       }
//     } catch (e) {
//       _productDetailsBySerialNumberResponse = null;
//       debugPrint("Exception: $e");
//
//       if (context.mounted) {
//         showSnackBar(context, 'Product Not Found . Please Scan Valid Bar Code.');
//         context.goNamed(
//           RouteName.dashboardScreen,
//           pathParameters: {'userType': 'customer'},
//           queryParameters: {'tab': '0'},
//         );
//       }
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }

// Call this before starting scanner
Future<bool> checkAndRequestCameraPermission(BuildContext context) async {
  var status = await Permission.camera.status;

  try{

    if (status.isGranted) {
      return true;
    }
    else if (status.isDenied) {
      // Request permission
      var result = await Permission.camera.request();
      if (result.isGranted) {
        return true;
      } else if (result.isDenied) {
        // User denied permission (but not permanently)
        await showPermissionDeniedDialog(context);
        return false;
      } else if (result.isPermanentlyDenied) {
        // User permanently denied - needs to open app settings
        await showOpenSettingsDialog(context);
        return false;
      }
    }
    else if (status.isPermanentlyDenied) {
      // Already permanently denied
      await showOpenSettingsDialog(context);
      return false;
    }
  }
  catch(e){
   if (kDebugMode) {
     print(e);
   }
  }
  return false;
}
// Future<bool> checkAndRequestCameraPermission(BuildContext context) async {
//   var status = await Permission.camera.status;
//
//   if (status.isGranted) {
//     return true;
//   }
//
//   if (status.isDenied || status.isRestricted) {
//     var result = await Permission.camera.request();
//     if (result.isGranted) {
//       return true;
//     } else if (result.isPermanentlyDenied) {
//       await showOpenSettingsDialog(context);
//       return false;
//     } else {
//       await showPermissionDeniedDialog(context);
//       return false;
//     }
//   }
//
//   if (status.isPermanentlyDenied) {
//     await showOpenSettingsDialog(context);
//     return false;
//   }
//   print("Camera status $status");
//   return false;
// }

Future<void> showPermissionDeniedDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Camera Permission'),
      content: const Text('Camera permission is required to scan barcodes. Please allow it.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> showOpenSettingsDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Camera Permission'),
      content: const Text(
          'Camera permission is permanently denied. Please enable it from app settings.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            openAppSettings();
            Navigator.of(context).pop();
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
}



// ─────────────────────────────────────────────────────────────────────────────

class ProductDetailProvider with ChangeNotifier {
  final BaseApiManager apiManager = BaseApiManager();
  late final ApiServices _apiServices;

  ProductDetailProvider() {
    _apiServices = ApiServices(apiManager: apiManager);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProductDetailsBySerialNumberResponse? _productDetailsBySerialNumberResponse;
  ProductDetailsBySerialNumberResponse? get productDetailsBySerialNumber =>
      _productDetailsBySerialNumberResponse;

  String? _barcode;
  bool _isScanning = true;
  double _blueLinePosition = 0;
  bool _movingDown = true;

  String? get barcode => _barcode;
  bool get isScanning => _isScanning;
  double get blueLinePosition => _blueLinePosition;

  void setBarcode(String code) {
    _barcode = code;
    _isScanning = false;
    notifyListeners();
  }

  void resetScanner() {
    _barcode = null;
    _isScanning = true;
    notifyListeners();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Animate a blue scanning line back and forth
  void updateBlueLine() {
    if (_disposed) return;
    if (_movingDown) {
      _blueLinePosition += 2;
      if (_blueLinePosition >= 230) _movingDown = false;
    } else {
      _blueLinePosition -= 2;
      if (_blueLinePosition <= 0) _movingDown = true;
    }
    notifyListeners();
  }

  /// Starts a continuous loop to animate the scanner's blue line.
  void startAnimationLoop() {
    Future.doWhile(() async {
      while(!_disposed){
        await Future.delayed(const Duration(milliseconds: 16));
        updateBlueLine();
      }
      return true;
    });
  }

  /// Checks and requests camera permission. Returns true if granted.


  Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Camera Permission'),
        content: const Text(
          'Camera permission is required to scan barcodes. Please allow it from settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showOpenSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Camera Permission'),
        content: const Text(
          'Camera permission is permanently denied. Please enable it from app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Initiates the barcode scanning process. Returns false if permission denied.
  Future<bool> startBarcodeScan(BuildContext context) async {
    final permissionGranted = await checkAndRequestCameraPermission(context);
    if (!permissionGranted) {
      return false;
    }
    resetScanner();
    return true;
  }

  /// Called when a barcode is detected. Fetches product details.
  Future<void> handleSerialNumberScan(
      BuildContext context, String barcode) async {
    try {
      _isLoading = true;
      notifyListeners();
      ApiResponse response =
      await _apiServices.getProductDetailBySerialNumber(barcode);

      if (response.status == 200 && response.data != null) {
        _productDetailsBySerialNumberResponse =
            ProductDetailsBySerialNumberResponse.fromJson(response.data!);
        AppLog.d(
            "Product Details Fetched: ${_productDetailsBySerialNumberResponse?.productName}");

        if (context.mounted) {
          context.pushNamed(
            RouteName.productDetailsScreen,
            extra: _productDetailsBySerialNumberResponse,
          );
        }
      } else {
        _productDetailsBySerialNumberResponse = null;
        if (context.mounted) {
          showSnackBar(context, 'Invalid Serial Number. No product found.');
          context.goNamed(
            RouteName.dashboardScreen,
            pathParameters: {'userType': 'customer'},
            queryParameters: {'tab': '0'},
          );
        }
      }
    } on DioException catch(dioError){
      _productDetailsBySerialNumberResponse = null;
      AppLog.e("DioException: ${dioError.message}");
      if(dioError.response?.statusCode == 404){
        //Product Not Found
        if (context.mounted) {
          showSnackBar(
              context, 'Product not found. Please scan a valid barcode.');
          Future.microtask((){
            if(context.mounted){
              context.goNamed(
                RouteName.dashboardScreen,
                pathParameters: {'userType': 'customer'},
                queryParameters: {'tab': '0'},
              );
            }
          });
        }else{
          if (context.mounted) {
            showSnackBar(context, 'Something went wrong. Please try again.');
          }
        }
      }
    }
    catch (e) {
      _productDetailsBySerialNumberResponse = null;
      AppLog.e("Unknown Exception: $e");
      if (context.mounted) {
        showSnackBar(context, 'Invalid code');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


