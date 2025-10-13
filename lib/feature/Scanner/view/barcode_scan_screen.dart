import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/controller/get_product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
 import '../../../core/custom_text.dart';
import '../../../core/routes/route_name.dart';

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _ScannerView();
    // return ChangeNotifierProvider(
    //   create: (_) => ProductDetailProvider()..startAnimationLoop(),
    //   child: const _ScannerView(),
    // );
  }
}
class _ScannerView extends StatefulWidget {
  const _ScannerView();
  @override
  State<_ScannerView> createState() => _ScannerViewState();
}
class _ScannerViewState extends State<_ScannerView> with WidgetsBindingObserver {
  late final ProductDetailProvider _scanProvider;

  MobileScannerController mobileScannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  @override
  void initState() {
    super.initState();
    _scanProvider = Provider.of<ProductDetailProvider>(context, listen: false);
    // Defer permission check & scan initialization until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mobileScannerController.start();
      final granted = await _scanProvider.startBarcodeScan(context);
      if (!granted && mounted) {
        // If permission denied, pop this screen
        context.pop();
      }
    });
  }

  @override
  void dispose() {
    mobileScannerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came back from background — recheck permission
      checkAndRequestCameraPermission(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: f15(text: "Scan Barcode", color: AppColor.primaryWhite),
            backgroundColor: AppColor.primaryColor,
            leading: IconButton(
              icon: SvgPicture.asset(AppIcons.arrow),
              onPressed: () {
                if (context.mounted) {
                  // context.goNamed(
                  //   RouteName.dashboardScreen,
                  //   pathParameters: {'userType': 'customer'},
                  //   queryParameters: {'tab': '0'},
                  // );
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          body: Stack(
            children: [
              MobileScanner(
                controller: mobileScannerController,
                onDetect: (BarcodeCapture capture) async {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final code = barcodes.first.rawValue;
                    if (code != null && _scanProvider.isScanning) {
                      _scanProvider.setBarcode(code);
                      await _scanProvider.handleSerialNumberScan(context, code);
                    }
                  }
                },
              ),
              _scannerOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scannerOverlay() {
    return Consumer<ProductDetailProvider>(
      builder: (context, scanProvider, child) {
        return Stack(
          children: [
            Container(color: AppColor.blackColor.withAlpha(120)),
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        color: Colors.transparent,
                      ),
                    ),
                    Positioned(
                        top: 0, left: 0, child: _cornerBox(topLeft: true)),
                    Positioned(
                        top: 0, right: 0, child: _cornerBox(topRight: true)),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: _cornerBox(bottomLeft: true)),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: _cornerBox(bottomRight: true)),

                    // Blue animated line
                    Positioned(
                      top: scanProvider.blueLinePosition,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 250,
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  if (scanProvider.isScanning)
                    CircularProgressIndicator(
                        strokeWidth: 2, color: AppColor.primaryWhite),
                  10.height,
                  CustomText(
                    text: scanProvider.isScanning
                        ? "Scanning the Barcode..."
                        : "Please Go Back and Come Again",
                    color: AppColor.primaryWhite,
                    fontSize: AppFontSize.s16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _cornerBox({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: _CornerPainter(
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  _CornerPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.primaryColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (topLeft) {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    }
    if (topRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    }
    if (bottomLeft) {
      path.moveTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, 0);
    }
    if (bottomRight) {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
