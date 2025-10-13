import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

import '../../../core/helper/app_log.dart';

// class CustomerCameraProvider extends ChangeNotifier {
//   late CameraController controller;
//   List<CameraDescription> _cameras = [];
//   bool isInitialized = false;
//   bool isRecording = false;
//   bool isFlashOn = false;
//   Timer? _timer;
//   int _seconds = 0;
//
//   String? recordedVideoPath;
//
//   String get recordingDuration {
//     final remaining = 30 - _seconds;
//     final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
//     final seconds = (remaining % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }
//
//   Future<bool> init(BuildContext context) async {
//     final camPermission = await _checkAndRequestPermission(Permission.camera, context);
//     final micPermission = await _checkAndRequestPermission(Permission.microphone, context);
//
//     if (!camPermission || !micPermission) {
//       isInitialized = false;
//       notifyListeners();
//       return false;
//     }else {
//       _cameras = await availableCameras();
//       controller = CameraController(_cameras[0], ResolutionPreset.high);
//
//       try {
//         await controller.initialize();
//         isInitialized = true;
//         notifyListeners();
//         return true;
//       } catch (e) {
//         isInitialized = false;
//         notifyListeners();
//         return false;
//       }
//     }
//   }
//
//   Future<bool> _checkAndRequestPermission(Permission permission, BuildContext context) async {
//     var status = await permission.status;
//
//     if (status.isGranted) return true;
//
//     if (status.isDenied) {
//       final result = await permission.request();
//       if (result.isGranted) return true;
//       if (result.isPermanentlyDenied) {
//         await _showOpenSettingsDialog(context);
//         return false;
//       }
//       return false;
//     }
//
//     if (status.isPermanentlyDenied) {
//       await _showOpenSettingsDialog(context);
//       return false;
//     }
//
//     return false;
//   }
//
//   Future<void> _showOpenSettingsDialog(BuildContext context) async {
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Permission Required'),
//         content: const Text(
//             'Please enable the required permissions from app settings to use this feature.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               openAppSettings();
//               Navigator.of(context).pop();
//             },
//             child: const Text('Open Settings'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> startRecording() async {
//     if (isRecording || !isInitialized) return;
//
//     try {
//       await controller.startVideoRecording();
//       isRecording = true;
//       recordedVideoPath = null;
//       _startTimer();
//       notifyListeners();
//     } catch (e) {
//       // handle error if needed
//     }
//   }
//
//   Future<void> stopRecording([BuildContext? context]) async {
//     if (!isRecording) return;
//
//     try {
//       final XFile file = await controller.stopVideoRecording();
//       isRecording = false;
//       _stopTimer();
//
//       final downloadsDirectory = Directory('/storage/emulated/0/Download');
//       if (!downloadsDirectory.existsSync()) {
//         downloadsDirectory.createSync(recursive: true);
//       }
//
//       final newFilePath = path.join(
//         downloadsDirectory.path,
//         'ACVMX_CUSTOMER_${DateTime.now().millisecondsSinceEpoch}.mp4',
//       );
//
//       final newFile = await File(file.path).copy(newFilePath);
//       recordedVideoPath = newFile.path;
//       notifyListeners();
//
//       if (context != null && context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Video saved to Downloads: ${newFile.path}")),
//         );
//       }
//     } catch (e) {
//       isRecording = false;
//       _stopTimer();
//       notifyListeners();
//
//       if (context != null && context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to save video: $e")),
//         );
//       }
//     }
//   }
//
//   void toggleFlash() async {
//     if (!isInitialized) return;
//
//     try {
//       if (controller.value.flashMode == FlashMode.torch) {
//         await controller.setFlashMode(FlashMode.off);
//         isFlashOn = false;
//       } else {
//         await controller.setFlashMode(FlashMode.torch);
//         isFlashOn = true;
//       }
//       notifyListeners();
//     } catch (e) {
//       // handle error if needed
//     }
//   }
//
//   void _startTimer() {
//     _seconds = 0;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       _seconds++;
//       notifyListeners();
//       if (_seconds >= 30) {
//         stopRecording();
//       }
//     });
//   }
//
//   void _stopTimer() {
//     _timer?.cancel();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     _stopTimer();
//     super.dispose();
//   }
// }



class CustomerCameraProvider extends ChangeNotifier {
  late CameraController controller;
  bool isInitialized = false;
  bool isRecording = false;
  bool isFlashOn = false;
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  Timer? _timer;
  int _seconds = 0;

  String? recordedVideoPath;
  String? thumbnailPath;

  String get recordingDuration {
    final remaining = 30 - _seconds;
    final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (remaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<bool> init(BuildContext context) async {
    final camPermission = await _checkAndRequestPermission(Permission.camera, context);
    final micPermission = await _checkAndRequestPermission(Permission.microphone, context);

    if (!camPermission || !micPermission) {
      isInitialized = false;
      notifyListeners();
      return false;
    }

    final cameras = await availableCameras();
    controller = CameraController(cameras.first, ResolutionPreset.high);

    try {
      await controller.initialize();
      isInitialized = true;
      notifyListeners();
      return true;
    } catch (e) {
      isInitialized = false;
      return false;
    }
  }

  Future<void> startRecording() async {
    if (!isInitialized || isRecording) return;

    try {
      await controller.startVideoRecording();
      isRecording = true;
      recordedVideoPath = null;
      thumbnailPath = null;
      _startTimer();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;

    try {
      _isProcessing = true;
      notifyListeners();

      final XFile rawVideo = await controller.stopVideoRecording();
      isRecording = false;
      _stopTimer();

      if(rawVideo.path.isEmpty){
        AppLog.e("Video path is empty");
        return ;
      }
      try{
        final compressed = await VideoCompress.compressVideo(
          rawVideo.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: true,
        );

        if (compressed == null || compressed.path == null || compressed.path!.isEmpty) {
          AppLog.e("Video compression failed or returned null path.");
          return;
        }

        recordedVideoPath = compressed.path;

        final thumbnailFile = await VideoCompress.getFileThumbnail(
          compressed.path!,
          quality: 75,
        );

        if (thumbnailFile == null) {
          AppLog.e("Thumbnail generation failed.");
          return;
        }

        final tempDir = await getTemporaryDirectory();
        final thumbPath = '${tempDir.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final thumbSaved = await File(thumbPath).writeAsBytes(await thumbnailFile.readAsBytes());
        thumbnailPath = thumbSaved.path;
      }
      catch(e){
        AppLog.e("Compression return null or empty path");
      }
    } catch (e) {
      AppLog.e("Error during stopRecording: $e");
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }


  Future<bool> _checkAndRequestPermission(Permission permission, BuildContext context) async {
    var status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied || status.isPermanentlyDenied) {
      final result = await permission.request();
      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        openAppSettings();
      }
    }

    return false;
  }

  void toggleFlash() async {
    if (!isInitialized) return;

    try {
      isFlashOn = !isFlashOn;
      await controller.setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
      notifyListeners();
    } catch (_) {}
  }

  void _startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      notifyListeners();
      if (_seconds >= 30) {
        stopRecording();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> clearCache() async {
    await VideoCompress.deleteAllCache();
    recordedVideoPath = null;
    thumbnailPath = null;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    _stopTimer();
    VideoCompress.cancelCompression();
    super.dispose();
  }
}
